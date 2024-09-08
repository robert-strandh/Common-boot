(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast
    (client environment (ast ico:special-variable-reference-ast))
  (let ((global-environment (trucler:global-environment client environment)))
    `(symbol-value ',(ico:name ast)
                   ',(clostrum-sys:variable-cell
                      client global-environment (ico:name ast))
                   dynamic-environment)))
