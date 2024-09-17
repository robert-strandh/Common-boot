(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast
    (client environment (ast ico:multiple-value-prog1-ast))
  (multiple-value-prog1
      (interpret-ast client environment (ico:values-ast ast))
    (interpret-implicit-progn-asts client environment (ico:form-asts ast))))
