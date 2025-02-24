(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:simple-setq-ast))
  (let* ((value-ast (ico:value-ast ast))
         (variable-name-ast (ico:variable-name-ast ast))
         (definition-ast (ico:definition-ast variable-name-ast))
         (*target-register* (find-register definition-ast)))
    (translate-ast client value-ast)))
