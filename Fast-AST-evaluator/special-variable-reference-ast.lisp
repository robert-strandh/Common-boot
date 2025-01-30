(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast
    (client (ast ico:special-variable-reference-ast))
  `(symbol-value ',(ico:name ast)
                 ',(clostrum-sys:variable-cell
                    client *global-environment* (ico:name ast))
                 dynamic-environment))
