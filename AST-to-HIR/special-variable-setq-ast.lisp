(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:special-variable-setq-ast))
  (let* ((value-register (make-instance 'hir:single-value-register))
         (*next-instruction*
           (if (null *target-register*)
               *next-instruction*
               (make-instance 'hir:assignment-instruction
                 :inputs (list value-register)
                 :outputs (list *target-register*)
                 :successors (list *next-instruction*))))
         (*next-instruction*
              (make-instance 'hir:special-variable-setq-instruction
                :origin (ico:origin ast)
                :variable-name (ico:name (ico:variable-name-ast ast))
                :inputs (list *dynamic-environment-register* value-register)
                :outputs '()
                :successors (list *next-instruction*)))
         (*target-register* value-register))
    (translate-ast client (ico:value-ast ast))))
