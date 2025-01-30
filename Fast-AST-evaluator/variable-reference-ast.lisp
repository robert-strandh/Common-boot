(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast
    (client (ast ico:variable-reference-ast))
  (lookup (ico:definition-ast ast)))
