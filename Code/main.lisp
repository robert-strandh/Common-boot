(cl:in-package #:common-boot)

(defvar *environment*)

(defun main ()
  (setf *environment* (make-instance 'clo:run-time-environment)))

