(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:special-variable-bind-ast))
  (let* ((binding-ast (ico:binding-ast ast))
         (form-ast (ico:form-ast binding-ast))
         (variable-name-ast (ico:variable-name-ast binding-ast))
         (form-asts (ico:form-asts ast))
         (current-dynamic-environment-register
           *dynamic-environment-register*)
         (*dynamic-environment-register*
           (make-instance 'hir:single-value-register))
         (*next-instruction*
           (translate-implicit-progn client form-asts))
         (value-register (make-instance 'hir:single-value-register))
         (name-register (make-instance 'hir:single-value-register))
         (*next-instruction*
           (make-instance 'hir:special-variable-binding-instruction
             :inputs (list current-dynamic-environment-register
                           name-register
                           value-register)
             :outputs (list *dynamic-environment-register*)
             :successors (list *next-instruction*)))
         (*target-register* value-register)
         (*next-instruction* (translate-ast client form-ast))
         (*target-register* name-register))
    (translate-ast client variable-name-ast)))
