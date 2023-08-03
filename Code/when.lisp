(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:when-ast))
  (reinitialize-instance ast
    :test-ast (convert-ast builder (ico:test-ast ast))
    :form-asts (convert-asts builder (ico:form-asts ast))))
