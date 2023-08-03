(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:ignore-errors-ast))
  (reinitialize-instance ast
    :form-asts (convert-asts builder (ico:form-asts ast))))
