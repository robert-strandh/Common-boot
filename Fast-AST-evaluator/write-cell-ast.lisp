(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:write-cell-ast))
  `(rplaca ,(translate-ast client (ico:cell-ast ast))
           ,(translate-ast client (ico:form-ast ast))))
