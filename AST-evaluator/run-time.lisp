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

(defclass continuation-entry (dynamic-environment-entry)
  ((%continuation
    :initarg :continuation
    :reader continuation)
   ))

(defclass block-entry (continuation-entry valid-p-mixin)
  ((%name :initarg :name :reader name)))

;;; This variable is used only to pass the dynamic environment over a
;;; function call.  The caller assigns the current dynamic environment
;;; to it, and the callee initializes its own lexical variable holding
;;; the dynamic environment to its value.
(defparameter *dynamic-environment* '())

(defun unwind (name dynamic-environment entry-type entry-name)
  (loop for rest on dynamic-environment
        for entry = (first rest)
        do (when (and (typep entry entry-type)
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
        finally (error "No valid ~a entry for ~s" entry-name name)))

(defun do-return-from (name dynamic-environment)
  (unwind name dynamic-environment 'block-entry "block"))

(defclass tag-entry (continuation-entry valid-p-mixin)
  ((%name :initarg :name :reader name)))

(defun do-go (name dynamic-environment)
  (unwind name dynamic-environment 'tag-entry "tag"))

(defclass catch-entry (continuation-entry valid-p-mixin)
  ((%name :initarg :name :reader name)))

(defun do-throw (name dynamic-environment)
  (unwind name dynamic-environment 'catch-entry "catch"))

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
             (return (value entry)))
        finally (if (clostrum-sys:variable-cell-boundp client cell)
                    (return (clostrum-sys:variable-cell-value client cell))
                    (error "unbound variable ~s" name))))

(defun (setf symbol-value) (value client name cell dynamic-environment)
  (loop for entry in dynamic-environment
        do (when (and (typep entry 'special-variable-entry)
                      (eq name (name entry)))
             (setf (value entry) value))
        finally (setf (clostrum-sys:variable-cell-value client cell)
                      value)))
