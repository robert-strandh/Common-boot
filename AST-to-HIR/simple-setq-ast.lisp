(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:simple-setq-ast))
  (let* ((value-ast (ico:value-ast ast))
         (variable-name-ast (ico:variable-name-ast ast))
         (definition-ast (ico:definition-ast variable-name-ast))
         (register-to-assign-to (find-register definition-ast))
         (*next-instruction*
           (make-instance 'hir:assignment-instruction
             :inputs (list register-to-assign-to)
             :outputs (list *target-register*)
             :successors (list *next-instruction*)))
         (*target-register* register-to-assign-to))
    (translate-ast client value-ast)))
