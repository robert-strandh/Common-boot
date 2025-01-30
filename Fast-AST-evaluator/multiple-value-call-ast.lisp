(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast
    (client (ast ico:multiple-value-call-ast))
  `(multiple-value-call
       ,(translate-ast client (ico:function-ast ast))
     ,@(loop for form-ast in (ico:form-asts ast)
             collect (translate-ast client form-ast))))
