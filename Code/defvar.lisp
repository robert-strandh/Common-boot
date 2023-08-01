(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:defvar-ast))
  (change-class (ico:variable-name-ast ast) 'ico:special-variable-bound-ast)
  (reinitialize-instance ast
    :form-ast (if (null (ico:form-ast ast))
                  nil
                  (convert-ast builder (ico:form-ast ast)))))
