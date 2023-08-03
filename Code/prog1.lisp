(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:prog1-ast))
  (reinitialize-instance ast
    :first-form-ast (convert-ast builder (ico:first-form-ast ast))
    :form-asts (convert-asts builder (ico:form-asts ast))))
