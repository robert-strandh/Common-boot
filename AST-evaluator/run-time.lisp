(cl:in-package #:common-boot-ast-evaluator)

(defclass stack-frame ()
  ((%continuation
    :initarg :continuation
    :reader continuaton)
   (%dynamic-environment
    :initarg :dynamic-environment
    :reader dynamic-environment)))

(defparameter *stack* '())

(defclass dynamic-environment-entry ()
  ((%stack :initarg :stack :reader stack)))

(defclass block-entry (dynamic-environment-entry)
  ())

(defclass tagbody-entry (dynamic-environment-entry)
  ())

(defclass catch-entry (dynamic-environment-entry)
  ())

(defclass unwind-protect-entry (dynamic-environment-entry)
  ())

(defclass special-variable-entry (dynamic-environment-entry)
  ())

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
    (setf *continuation* (continuation entry)
          *dynamic-environment* (dynamic-environment entry))))
