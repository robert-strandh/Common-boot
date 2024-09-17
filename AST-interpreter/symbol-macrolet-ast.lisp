(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:symbol-macrolet-ast))
  (interpret-implicit-progn-asts client environment (ico:form-asts ast)))
