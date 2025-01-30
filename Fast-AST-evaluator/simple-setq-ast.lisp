(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:simple-setq-ast))
  `(setq ,(translate-ast client (ico:variable-name-ast ast))
         ,(translate-ast client (ico:value-ast ast))))
