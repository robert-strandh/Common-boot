(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:prog2-ast))
  (reinitialize-instance ast
    :first-form-ast (convert-ast builder (ico:first-form-ast ast))
    :second-form-ast (convert-ast builder (ico:second-form-ast ast))
    :form-asts (convert-asts builder (ico:form-asts ast))))
