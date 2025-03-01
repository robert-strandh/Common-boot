(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:special-variable-setq-ast))
  (let* ((symbol-register (make-instance 'hir:single-value-register))
         (value-register (make-instance 'hir:single-value-register))
         (*next-instruction*
           (make-instance 'hir:special-variable-setq-instruction
             :origin (ico:origin ast)
             :inputs (list symbol-register value-register)
             :outputs '()
             :successors (list *next-instruction*)))
         (*target-register* value-register)
         (*next-instruction*
           (translate-ast client (ico:value-ast ast)))
         (*target-register* symbol-register))
    (translate-ast client (ico:variable-name-ast ast))))
