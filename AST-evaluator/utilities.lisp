(cl:in-package #:common-boot-ast-evaluator)

(defun lookup (ast environment)
  (gethash ast environment))

(defun (setf lookup) (value ast environment)
  (setf (gethash ast environment) value))
