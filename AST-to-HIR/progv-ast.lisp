(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:progv-ast))
  (let* ((existing-dynamic-environment-register
           *dynamic-environment-register*)
         (new-dynamic-environment-register
           (make-instance 'hir:single-value-register
             :name "new dynamic env"))
         (symbols-register
           (make-instance 'hir:single-value-register))
         (values-register
           (make-instance 'hir:single-value-register))
         (*dynamic-environment-register*
           new-dynamic-environment-register)
         (*next-instruction*
           (translate-implicit-progn client (ico:form-asts ast)))
         (*next-instruction*
           (make-instance 'hir:progv-instruction
             :origin (ico:origin ast)
             :inputs (list existing-dynamic-environment-register
                           symbols-register
                           values-register)
             :outputs (list new-dynamic-environment-register)
             :successors (list *next-instruction*)))
         (*dynamic-environment-register*
           existing-dynamic-environment-register)
         (*target-register* values-register)
         (*next-instruction*
           (translate-ast client (ico:values-ast ast)))
         (*target-register* symbols-register))
    (translate-ast client (ico:symbols-ast ast))))
