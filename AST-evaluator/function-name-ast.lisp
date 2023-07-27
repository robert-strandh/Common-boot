(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps
    (client (ast ico:function-reference-ast) environment continuation)
  (let ((definition-ast (ico:function-name-definition-ast ast)))
    `(step (list ,(lookup definition-ast environment))
           ,continuation)))

(defmethod cps
    (client
     (ast ico:global-function-name-reference-ast)
     environment
     continuation)
  ;; FIXME: refer to Clostrum instead.
  `(step (list (fdefinition ,(ico:name ast))) ,continuation))
