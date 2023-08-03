(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:multiple-value-list-ast))
  (reinitialize-instance ast
    :form-asts (convert-asts builder (ico:form-asts ast))))
