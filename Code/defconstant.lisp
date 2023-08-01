(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:defconstant-ast))
  (reinitialize-instance ast
    :form-ast (convert-ast builder (ico:form-ast ast))))
