(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast
    (client (ast ico:multiple-value-prog1-ast))
  `(multiple-value-prog1
       ,(translate-ast client (ico:values-ast ast))
     ,@(translate-implicit-progn client (ico:form-asts ast))))
