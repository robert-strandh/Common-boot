(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:return-ast))
  (reinitialize-instance ast
    :form-ast (convert-optional-ast biulder (ico:form-ast ast))))
