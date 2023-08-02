(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:return-ast))
  (reinitialize-instance ast
    :form-ast (if (null (ico:form-ast ast))
                  nil
                  (convert-ast builder (ico:form-ast ast)))))
