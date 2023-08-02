(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:multiple-value-list-ast))
  (reinitialize-instance ast
    :form-asts
    (loop for form-ast in (ico:form-asts ast)
          do (convert-ast builder form-ast))))
