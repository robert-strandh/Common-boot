(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:progn-ast))
  (reinitialize-instance ast
    :form-asts
    (loop for body-ast in (ico:form-asts ast)
          collect (convert-ast builder body-ast))))
