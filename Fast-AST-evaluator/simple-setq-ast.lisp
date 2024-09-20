(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:simple-setq-ast))
  `(setq ,(translate-ast client environment (ico:variable-name-ast ast))
         ,(translate-ast client environment (ico:value-ast ast))))
