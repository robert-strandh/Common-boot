(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast
    (client environment (ast ico:variable-reference-ast))
  (lookup (ico:definition-ast ast) environment))
