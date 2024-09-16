(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast
    (client environment (ast ico:variable-reference-ast))
  (lookup (ico:variable-definition-ast ast) environment))
