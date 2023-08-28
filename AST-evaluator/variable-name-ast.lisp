(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps
    (client (ast ico:variable-reference-ast) continuation)
  (let ((definition-ast (ico:variable-definition-ast ast)))
    `(step (list (car ,(lookup definition-ast)))
           ,continuation)))

(defmethod cps
    (client (ast ico:special-variable-reference-ast) continuation)
  `(step (list (symbol-value
                client
                ',(ico:name ast)
                (clostrum-sys:variable-cell
                 environment ',(ico:name ast))))
         ,continuation))
