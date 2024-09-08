(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast
    (client environment (ast ico:multiple-value-prog1-ast))
  `(multiple-value-prog1
       ,(translate-ast client environment (ico:values-ast ast))
     ,@(translate-implicit-progn client environment (ico:form-asts ast))))
