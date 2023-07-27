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

(defclass continuation-entry (dynamic-environment-entry)
  ((%continuation
    :initarg :continuation
    :reader continuation)))

(defclass block-entry (continuation-entry)
  ((%name :initarg :name :reader name)))

(defclass tagbody-entry (continuation-entry)
  ())

(defclass catch-entry (continuation-entry)
  ())

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
          :continuaton *continuation*
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

