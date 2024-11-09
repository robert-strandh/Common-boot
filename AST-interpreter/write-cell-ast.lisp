(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:write-cell-ast))
  (let ((value (interpret-ast client environment (ico:form-ast ast))))
    (rplaca (interpret-ast client environment (ico:cell-ast ast))
            value)
    value))
