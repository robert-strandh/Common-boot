(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:catch-ast))
  (reinitialize-instance ast
    :tag-form-ast (convert-ast builder (ico:tag-form-ast ast))
    :form-asts
    (loop for body-ast in (ico:form-asts ast)
          collect (convert-ast builder body-ast))))
