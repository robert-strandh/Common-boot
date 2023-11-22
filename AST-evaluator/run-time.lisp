(cl:in-package #:common-boot-ast-evaluator)

(defclass stack-frame ()
  ((%continuation
    :initarg :continuation
    :reader continuation)))

(defparameter *continuation* nil)

(defparameter *stack* '())

(defclass dynamic-environment-entry ()
  ((%stack :initarg :stack :reader stack)))

(defclass valid-p-mixin ()
  ((%valid-p
    :initform t
    :accessor valid-p)))

(defgeneric invalidate-entry (entry))

;;; The default method is invoked when ENTRY is not an instance of
;;; VALID-P-MIXIN.
(defmethod invalidate-entry (entry)
  nil)

(defmethod invalidate-entry ((entry valid-p-mixin))
  (setf (valid-p entry) nil))

(defclass continuation-entry-mixin ()
  ((%continuation
    :initarg :continuation
    :reader continuation)))

(defclass block-entry
    (dynamic-environment-entry continuation-entry-mixin valid-p-mixin)
  ((%name :initarg :name :reader name)))

(defmethod print-object ((object block-entry) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "name: ~s valid-p: ~s"
            (name object) (valid-p object))))

;;; This variable is used only to pass the dynamic environment over a
;;; function call.  The caller assigns the current dynamic environment
;;; to it, and the callee initializes its own lexical variable holding
;;; the dynamic environment to its value.
(defparameter *dynamic-environment* '())

(defun do-return-from (name dynamic-environment)
  (loop for rest on dynamic-environment
        for entry = (first rest)
        do (when (and (typep entry 'block-entry)
                      (eq name (name entry)))
             (if (valid-p entry)
                 ;; FIXME: handle UNWIND-PROTECT.
                 (progn 
                   (loop for entry-to-invalidate in dynamic-environment
                         until (eq entry-to-invalidate entry)
                         do (setf (valid-p entry-to-invalidate) nil))
                   ;; for RETURN-FROM, we also want to invalidate the
                   ;; entry representing the associated BLOCK.
                   (setf (valid-p entry) nil)
                   (setf *continuation* (continuation entry))
                   (setf *stack* (stack entry))
                   (return))
                 ;; For now, signal a host error.  It would be better
                 ;; to call the target function ERROR.
                 (error "Attempt to use an expired entry ~s~%"
                        entry)))
        finally (error "No valid BLOCK entry for ~s" name)))

(defclass tag-entry (continuation-entry-mixin)
  ((%name :initarg :name :reader name)))

(defmethod print-object ((object tag-entry) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "name: ~s" (name object))))

(defclass tagbody-entry (dynamic-environment-entry valid-p-mixin)
  ((%tag-entries :initarg :tag-entries :initform '() :reader tag-entries)))

(defmethod print-object ((object tagbody-entry) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "valid-p: ~s tag-entries ~s"
            (valid-p object) (tag-entries object))))

(defun do-go (name dynamic-environment)
  (loop for rest on dynamic-environment
        for entry = (first rest)
        do (when (and (typep entry 'tagbody-entry)
                      (member-if (lambda (e) (eq (name e) name))
                                 (tag-entries entry)))
             (if (valid-p entry)
                 ;; FIXME: handle UNWIND-PROTECT.
                 (progn 
                   (loop for entry-to-invalidate in dynamic-environment
                         until (eq entry-to-invalidate entry)
                         do (setf (valid-p entry-to-invalidate) nil))
                   ;; Contrary to the BLOCK entry, we do not want to
                   ;; invalidate the TAGBODY-ENTRY, as it will be used
                   ;; several times.  It is invalidated after the last
                   ;; form has been executed.
                   (let ((tag-entry (find-if (lambda (e) (eq (name e) name))
                                             (tag-entries entry))))
                     (setf *continuation* (continuation tag-entry)))
                   (setf *stack* (stack entry))
                   (return))
                 ;; For now, signal a host error.  It would be better
                 ;; to call the target function ERROR.
                 (error "Attempt to use an expired entry ~s~%"
                        entry)))
        finally (error "No valid TAG entry for ~s" name)))

(defclass catch-entry
    (dynamic-environment-entry continuation-entry-mixin valid-p-mixin)
  ((%name :initarg :name :reader name)))

(defun do-throw (name dynamic-environment)
  (loop for rest on dynamic-environment
        for entry = (first rest)
        do (when (and (typep entry 'catch-entry)
                      (eq name (name entry)))
             (if (valid-p entry)
                 ;; FIXME: handle UNWIND-PROTECT.
                 (progn 
                   (loop for entry-to-invalidate in dynamic-environment
                         until (eq entry-to-invalidate entry)
                         do (setf (valid-p entry-to-invalidate) nil))
                   (setf *continuation* (continuation entry))
                   (setf *stack* (stack entry))
                   (return))
                 ;; For now, signal a host error.  It would be better
                 ;; to call the target function ERROR.
                 (error "Attempt to use an expired entry ~s~%"
                        entry)))
        finally (error "No valid catch entry for ~s" name)))

(defclass unwind-protect-entry (dynamic-environment-entry)
  ())

(defclass special-variable-entry (dynamic-environment-entry)
  ((%name
    :initarg :name
    :reader name)
   (%value
    :initarg :value
    :accessor value)))

(defparameter *arguments* nil)

(defun step (arguments continuation)
  (setf *arguments* arguments
        *continuation* continuation))

(defun push-stack ()
  (push (make-instance 'stack-frame
          :continuation *continuation*)
        *stack*))

(defun pop-stack ()
  (let ((frame (pop *stack*)))
    (setf *continuation* (continuation frame))))

(defun push-stack-operation (client)
  (declare (ignore client))
  `(push-stack))

(defun pop-stack-operation (client)
  (declare (ignore client))
  `(pop-stack))

(defun symbol-value (client name cell dynamic-environment)
  (loop for entry in dynamic-environment
        do (when (and (typep entry 'special-variable-entry)
                      (eq name (name entry)))
             (if (slot-boundp entry '%value)
                 (return (value entry))
                 (error "unbound variable ~s" name)))
        finally (if (clostrum-sys:variable-cell-boundp client cell)
                    (return (clostrum-sys:variable-cell-value client cell))
                    (error "unbound variable ~s" name))))

(defun (setf symbol-value) (value client name cell dynamic-environment)
  (loop for entry in dynamic-environment
        do (when (and (typep entry 'special-variable-entry)
                      (eq name (name entry)))
             (setf (value entry) value))
        finally (return (setf (clostrum-sys:variable-cell-value client cell)
                              value))))

(defun call-function (function arguments)
  (if (typep function 'cps-function)
      (step arguments function)
      (progn (setf *arguments*
                   (multiple-value-list (apply function arguments)))
             (pop-stack))))
