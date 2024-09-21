(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast
    (client environment (ast special-variable-cell-ast))
  (symbol-value (name ast) (cell ast) *dynamic-environment*))
