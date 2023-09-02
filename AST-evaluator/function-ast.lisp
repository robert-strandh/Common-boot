(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:function-ast) continuation)
  (let ((name-ast (ico:name-ast ast)))
    (if (typep name-ast 'ico:function-name-ast)
        (cps client name-ast continuation)
        (cps-function-ast
         client
         (ico:lambda-list-ast ast)
         (ico:form-asts ast)
         continuation))))
