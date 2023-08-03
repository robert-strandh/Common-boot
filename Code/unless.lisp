(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:unless-ast))
  (reinitialize-instance ast
    :test-ast (convert-ast builder (ico:test-ast ast))
    :form-asts (convert-asts builder (ico:form-asts ast))))
