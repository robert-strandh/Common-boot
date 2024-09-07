(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast
    (client environment (ast ico:multiple-value-call-ast))
  `(multiple-value-call
       ,(translate-ast client environment (ico:function-ast ast))
     ,@(loop for form-ast in (ico:form-asts ast)
             collect (translate-ast client environment form-ast))))
