(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast
    (client environment (ast ico:function-reference-ast))
  (let ((definition-ast (ico:local-function-name-definition-ast ast)))
    (lookup definition-ast environment)))
