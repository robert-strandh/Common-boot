(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps
    (client environment (ast ico:function-reference-ast) continuation)
  (let ((definition-ast (ico:local-function-name-definition-ast ast)))
    `(step (list ,(lookup definition-ast)) ,continuation)))

(defmethod cps
    (client environment
     (ast ico:global-function-name-reference-ast)
     continuation)
  (let* ((name (ico:name ast))
         (cell (clostrum-sys:operator-cell client environment name)))
    (when (null cell)
      (error "No cell for ~s" name))
    `(step (list (car ',cell))
           ,continuation)))
