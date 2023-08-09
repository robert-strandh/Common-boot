(cl:in-package #:common-boot)

;;; FIXME: Add the symbol to the environment.
(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:with-package-iterator-ast))
  (reinitialize-instance ast
    :package-list-ast (convert-ast builder (ico:package-list-ast ast))
    :form-asts (convert-asts builder (ico:form-asts ast))))
