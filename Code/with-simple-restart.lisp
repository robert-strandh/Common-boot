(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:with-simple-restart-ast))
  (reinitialize-instance ast
    :format-control-ast (convert-ast builder (ico:format-control-ast ast))
    :format-argument-asts (convert-asts builder (ico:format-argument-asts ast))
    :form-asts (convert-asts builder (ico:form-asts ast))))
