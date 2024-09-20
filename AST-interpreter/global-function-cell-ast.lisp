(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast
    (client environment (ast global-function-cell-ast))
  (car (cell ast)))
