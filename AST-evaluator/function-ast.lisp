(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client environment (ast ico:function-ast) continuation)
  (let ((name-ast (ico:name-ast ast)))
    (if (typep name-ast 'ico:function-name-ast)
        (cps client environment name-ast continuation)
        (cps-function-ast
         client environment
         (ico:lambda-list-ast name-ast)
         (ico:form-asts name-ast)
         (ico:origin ast)
         continuation))))
