(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:read-cell-ast))
  `(car ,(translate-ast client environment (ico:cell-ast ast))))
