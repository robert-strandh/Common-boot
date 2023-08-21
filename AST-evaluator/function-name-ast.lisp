(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps
    (client (ast ico:function-reference-ast) environment continuation)
  (let ((definition-ast (ico:local-function-name-definition-ast ast)))
    `(step (list ,(lookup definition-ast))
           ,continuation)))

(defmethod cps
    (client
     (ast ico:global-function-name-reference-ast)
     environment
     continuation)
  `(step (list (clostrum:fdefinition
                client
                (trucler:global-environment client environment)
                ',(ico:name ast)))
         ,continuation))
