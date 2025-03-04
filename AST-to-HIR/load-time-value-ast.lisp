(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:load-time-value-ast))
  (translate-ast client (ico:form-ast ast)))
