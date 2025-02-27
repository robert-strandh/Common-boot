(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:read-cell-ast))
  (let* ((register (make-instance 'hir:single-value-register))
         (*next-instruction*
           (make-instance 'hir:read-cell-instruction
             :inputs (list register)
             :outputs (list *target-register*)
             :successors (list *next-instruction*)))
         (*target-register* register))
    (translate-ast client (ico:cell-ast ast))))
