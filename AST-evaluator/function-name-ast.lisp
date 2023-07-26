(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps
    (client (ast ico:variable-reference-ast) environment continuation)
  (let ((definition-ast (ico:variable-definition-ast ast)))
    `(funcall ,continuation (list ,(lookup definition-ast environment)))))

(defmethod cps
    (client (ast ico:special-variable-reference-ast) environment continuation)
  `(funcall ,continuation (list (fdefinition ,(ico:name ast)))))
