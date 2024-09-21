(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast
    (client environment (ast ico:special-variable-setq-ast))
  (let ((variable-name-ast (ico:variable-name-ast ast))
        (value-ast (ico:value-ast ast)))
    (setf (symbol-value
           (name variable-name-ast)
           (cell variable-name-ast)
           *dynamic-environment*)
          (interpret-ast client environment value-ast))))
