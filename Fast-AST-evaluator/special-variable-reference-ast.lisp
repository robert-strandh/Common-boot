(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast
    (client environment (ast ico:special-variable-reference-ast))
  `(symbol-value ',(ico:name ast)
                 ',(clostrum-sys:variable-cell
                    client environment (ico:name ast))
                 dynamic-environment))
