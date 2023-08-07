(cl:in-package #:common-boot-ast-evaluator)

(defclass stack-frame ()
  ((%continuation
    :initarg :continuation
    :reader continuation)
   (%dynamic-environment
    :initarg :dynamic-environment
    :reader dynamic-environment)))

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

(defclass block-entry (dynamic-environment-entry valid-p-mixin)
  ((%name :initarg :name :reader name)))

(defun do-return-from (name)
  (loop for rest on *dynamic-environment*
        for entry = (first rest)
        do (when (and (typep entry 'block-entry)
                      (eq name (name entry)))
             (if (valid-p entry)
                 ;; FIXME: handle UNWIND-PROTECT.
                 (progn 
                   (loop for entry-to-invalidate in *dynamic-environment*
                         until (eq entry-to-invalidate entry)
                         do (setf (valid-p entry-to-invalidate) nil))
                   (setf *stack* (stack entry))
                   (pop-stack))
                 ;; For now, signal a host error.  It would be better
                 ;; to call the target function ERROR.
                 (error "attempt to use an expired entry ~s~%"
                        entry)))))

(defclass tag-entry (dynamic-environment-entry valid-p-mixin)
  ((%name :initarg :name :reader name)
   (%continuation
    :initarg :continuation
    :reader continuation)))

(defclass catch-entry (continuation-entry)
  ((%tag :initarg :tag :reader tag)))

(defclass unwind-protect-entry (dynamic-environment-entry)
  ())

(defclass special-variable-entry (dynamic-environment-entry)
  ((%name
    :initarg :name
    :reader name)
   (%value
    :initarg :value
    :reader value)))

(defparameter *dynamic-environment* '())

(defparameter *continuation* nil)

(defparameter *arguments* nil)

(defun step (arguments continuation)
  (setf *arguments* arguments
        *continuation* continuation))

(defun push-stack ()
  (push (make-instance 'stack-frame
          :continuation *continuation*
          :dynamic-environment *dynamic-environment*)
        *stack*))

(defun pop-stack ()
  (let ((frame (pop *stack*)))
    (setf *continuation* (continuation frame)
          *dynamic-environment* (dynamic-environment frame))))

(defun push-stack-operation (client)
  (declare (ignore client))
  `(push-stack))

(defun pop-stack-operation (client)
  (declare (ignore client))
  `(pop-stack))

(defun symbol-value (client name cell)
  (loop for entry in *dynamic-environment*
        do (when (and (typep entry 'special-variable-entry)
                      (eq name (name entry)))
             (return (value entry)))
        finally (if (clostrum-sys:variable-cell-boundp client cell)
                    (return (clostrum-sys:variable-cell-value client cell))
                    (error "unbound variable ~s" name))))
