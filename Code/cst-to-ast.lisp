(cl:in-package #:common-boot)

(defun cst-to-ast (client cst environment)
  (let ((*subforms-are-top-level-p* t)
        (*compile-time-too* nil))
    (convert client cst environment)))

(defclass client (trucler-reference:client)
  ())
