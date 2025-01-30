(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:load-time-value-ast))
  (translate-ast client (ico:form-ast ast)))
