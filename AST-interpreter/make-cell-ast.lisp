(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:make-cell-ast))
  (list (interpret-ast client environment (ico:form-ast ast))))
