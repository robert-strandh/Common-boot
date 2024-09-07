(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client enviroment (ast ico:the-ast))
  (translate-ast client ast (ico:form-ast ast)))
