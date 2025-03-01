(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:catch-ast))
  (let* ((tag-register
           (make-instance 'hir:single-value-register
             :name "tag"))
         (existing-dynamic-environment-register
           *dynamic-environment-register*)
         (new-dynamic-environment-register
           (make-instance 'hir:single-value-register
             :name "new dynamic env"))
         (next-instruction *next-instruction*)
         (target-register *target-register*)
         (*dynamic-environment-register* new-dynamic-environment-register)
         (body-instruction
           (translate-implicit-progn client (ico:form-asts ast)))
         (*next-instruction*
           (make-instance 'hir:catch-instruction
             :origin (ico:origin ast)
             :inputs (list existing-dynamic-environment-register
                      tag-register)
             :outputs (list new-dynamic-environment-register
                       target-register)
             :successors (list body-instruction next-instruction))))
    (translate-ast client (ico:tag-ast ast))))
