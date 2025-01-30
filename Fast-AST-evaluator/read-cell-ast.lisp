(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:read-cell-ast))
  `(car ,(translate-ast client (ico:cell-ast ast))))
