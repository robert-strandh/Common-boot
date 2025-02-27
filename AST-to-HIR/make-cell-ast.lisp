(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:make-cell-ast))
  (let* ((register (make-instance 'hir:single-value-register))
         (*next-instruction*
           (make-instance 'hir:make-cell-instruction
             :inputs (list register)
             :outputs (list *target-register*)
             :successors (list *next-instruction*)))
         (*target-register* register))
    (translate-ast client (ico:form-ast ast))))
