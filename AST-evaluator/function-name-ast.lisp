(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps
    (client environment (ast ico:function-reference-ast) continuation)
  (let ((definition-ast (ico:definition-ast ast)))
    `(step (list ,(lookup definition-ast)) ,continuation)))

(defmethod cps
    (client environment
     (ast ico:global-function-name-reference-ast)
     continuation)
  (let* ((name (ico:name ast))
         (cell (clostrum:ensure-operator-cell client environment name)))
    `(step (list (car ',cell))
           ,continuation)))
