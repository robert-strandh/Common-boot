(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps
    (client (ast ico:variable-reference-ast) environment continuation)
  (let ((definition-ast (ico:variable-definition-ast ast)))
    `(step (list ,(lookup definition-ast environment))
           ,continuation)))

(defmethod cps
    (client (ast ico:special-variable-reference-ast) environment continuation)
  `(step (list (symbol-value
                client
                ',(ico:name ast)
                (clostrum-sys:variable-cell
                 environment ',(ico:name ast))))
         ,continuation))
