(cl:in-package #:common-boot)

;;; FIXME: Add the symbol to the environment.
(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:with-hash-table-iterator-ast))
  (reinitialize-instance ast
    :hash-table-ast (convert-ast builder (ico:hash-table-ast ast))
    :form-asts (convert-asts builder (ico:form-asts ast))))
