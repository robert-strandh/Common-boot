(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:throw-ast))
  (reinitialize-instance ast
    :tag-form-ast (convert-ast builder (ico:tag-form-ast ast))
    :form-ast (convert-ast builder (ico:form-ast ast))))
