(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:the-ast))
  (interpret-ast client environment (ico:form-ast ast)))
