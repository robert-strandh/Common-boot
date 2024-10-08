(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast
    (client environment (ast ico:special-variable-setq-ast))
  (let ((variable-name-ast (ico:variable-name-ast ast)))
    `(setf (symbol-value
            ',(ico:name variable-name-ast)
            ',(clostrum-sys:variable-cell
               client
               environment
               (ico:name variable-name-ast))
            dynamic-environment)
           ,(translate-ast client environment (ico:value-ast ast)))))
