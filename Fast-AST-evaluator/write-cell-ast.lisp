(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:write-cell-ast))
  `(rplaca ,(translate-ast client environment (ico:cell-ast ast))
           ,(translate-ast client environment (ico:form-ast ast))))
