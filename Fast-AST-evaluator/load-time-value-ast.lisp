(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:load-time-value-ast))
  (translate-ast client environment (ico:form-ast ast)))
