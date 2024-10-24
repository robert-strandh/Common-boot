(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast
    (client enviroment (ast ico:variable-reference-ast))
  (lookup (ico:definition-ast ast)))
