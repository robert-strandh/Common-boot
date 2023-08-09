(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:with-condition-restarts-ast))
  (reinitialize-instance ast
    :condition-form-ast (convert-ast builder (ico:condition-form-ast ast))
    :restarts-form-ast (convert-ast builder (ico:restarts-form-ast ast))
    :form-asts
    (loop for body-ast in (ico:form-asts ast)
          collect (convert-ast builder body-ast))))
