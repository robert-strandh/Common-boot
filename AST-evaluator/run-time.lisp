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

(defclass unwind-protect-entry (dynamic-environment-entry)
  ((%closure :initarg :closure :reader closure)))

;;; This variable is used only to pass the dynamic environment over a
;;; function call.  The caller assigns the current dynamic environment
;;; to it, and the callee initializes its own lexical variable holding
;;; the dynamic environment to its value.
(defparameter *dynamic-environment* '())

;;; Unwind the dynamic environment up to, but not including ENTRY.  If
;;; this function was called as a result of a RETURN-FROM or a THROW,
;;; the caller must then pop off ENTRY, whereas if this function was
;;; called as a result of a GO, then ENTRY is kept.  ENTRY is
;;; invalidated by this function if and only if INVALIDATE-ENTRY-P is
;;; true.  So if this function is called as a result of a RETURN-FROM
;;; or a THROW, then INVALIDATE-ENTRY-P is true, but if it is called
;;; as a result of a GO, then INVALIDATE-ENTRY-P is false.
(defun unwind (entry dynamic-environment invalidate-entry-p)
  ;; Start by invalidating every entry before but not including ENTRY.
  (loop for entry-to-invalidate in dynamic-environment
        until (eq entry-to-invalidate entry)
        do (invalidate-entry entry-to-invalidate))
  ;; Then invalidate ENTRY if and only if INVALIDATE-ENTRY-P is true.
  (when invalidate-entry-p
    (invalidate-entry entry))
  ;; Unwind the dynamic environment by executing any UNWIND-PROTECT
  ;; that precedes ENTRY.
  (loop for tail on dynamic-environment
        for (maybe-unwind-protect-entry . rest) = tail
        until (eq maybe-unwind-protect-entry entry)
        when (typep maybe-unwind-protect-entry 'unwind-protect-entry)
          do (funcall (closure maybe-unwind-protect-entry))
             ;; Finally return the dynamic environment with ENTRY on
             ;; top, so that the caller can set CONTINUATION.
        finally (return tail)))

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
                         do (invalidate-entry entry-to-invalidate))
                   ;; for RETURN-FROM, we also want to invalidate the
                   ;; entry representing the associated BLOCK.
                   (invalidate-entry entry)
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
                         do (invalidate-entry entry-to-invalidate))
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
                         do (invalidate-entry entry-to-invalidate))
                   (setf *continuation* (continuation entry))
                   (setf *stack* (stack entry))
                   (return))
                 ;; For now, signal a host error.  It would be better
                 ;; to call the target function ERROR.
                 (error "Attempt to use an expired entry ~s~%"
                        entry)))
        finally (error "No valid catch entry for ~s" name)))

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
