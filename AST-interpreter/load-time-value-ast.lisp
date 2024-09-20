(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:load-time-value-ast))
  (interpret-ast client environment (ico:form-ast ast)))
