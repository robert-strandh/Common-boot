(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:setq-ast))
  `(setq ,@(loop for variable-name-ast in (ico:variable-name-asts ast)
                 for value-ast in (ico:value-asts ast)
                 collect (translate-ast client environment variable-name-ast)
                 collect (translate-ast client environment value-ast))))
