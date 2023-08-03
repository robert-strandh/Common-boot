(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:return-ast))
  (reinitialize-instance ast
    :form-ast (convert-optional-ast builder (ico:form-ast ast))))
