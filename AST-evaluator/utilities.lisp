(cl:in-package #:common-boot-ast-evaluator)

(defun lookup (ast environment)
  (gethash ast environment))
