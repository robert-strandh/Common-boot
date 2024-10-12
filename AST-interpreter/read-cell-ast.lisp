(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:read-cell-ast))
  (car (interpret-ast client environment (ico:cell-ast ast))))
