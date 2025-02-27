(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:write-cell-ast))
  (let* ((cell-register (make-instance 'hir:single-value-register))
         (form-register (make-instance 'hir:single-value-register))
         (*next-instruction*
           (make-instance 'hir:write-cell-instruction
             :inputs (list cell-register form-register)
             :outputs '()
             :successors (list *next-instruction*)))
         (*target-register* form-register)
         (*next-instruction*
           (translate-ast client (ico:form-ast ast)))
         (*target-register* cell-register))
    (translate-ast client (ico:cell-ast ast))))
