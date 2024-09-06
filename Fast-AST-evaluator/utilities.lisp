(cl:in-package #:common-boot-fast-ast-evaluator)

;;; During host form creation, this variable holds a hash table that
;;; maps target objects such as variables and tags to host names.
(defvar *host-names*)

(defun lookup (ast)
  (multiple-value-bind (result presentp)
      (gethash ast *host-names*)
    (assert presentp)
    result))

(defun (setf lookup) (value ast)
  (setf (gethash ast *host-names*) value))
