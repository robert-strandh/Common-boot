(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:the-ast))
  (translate-ast client (ico:form-ast ast)))
