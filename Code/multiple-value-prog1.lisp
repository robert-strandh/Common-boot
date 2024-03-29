(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:multiple-value-prog1-ast))
  (reinitialize-instance ast
    :values-ast (convert-ast builder (ico:values-ast ast))
    :form-asts
    (loop for body-ast in (ico:form-asts ast)
          collect (convert-ast builder body-ast))))
