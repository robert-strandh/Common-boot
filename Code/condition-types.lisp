(cl:in-package #:common-boot)

(define-condition no-function-description (warning)
  ((%name :initarg :name :reader name))
  (:report (lambda (condition stream)
             (format stream
                     "Undefined function named ~s"
                     (name condition)))))
