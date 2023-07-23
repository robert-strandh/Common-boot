(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:progv-ast))
  (reinitialize-instance ast
    :symbols-ast (convert-ast builder (ico:symbols-ast ast))
    :values-ast (convert-ast builder (ico:values-ast ast))
    :form-ast (loop for form-ast in (ico:form-asts ast)
                    collect (convert-ast builder form-ast))))
