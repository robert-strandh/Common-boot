(cl:in-package #:common-boot-ast-evaluator)

(defun evaluator-step ()
  (apply *continuation* *arguments*)
  *arguments*)
