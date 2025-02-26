(cl:in-package #:common-boot-ast-to-hir)

(defgeneric translate-ast (client ast))

(defun translate (client ast)
  (let* ((*registers* (make-hash-table :test #'eq))
         (*target-register*
           (make-instance 'hir:multiple-value-register))
         (*dynamic-environment-register*
           (make-instance 'hir:literal :value '()))
         (*static-environment-register*
           (make-instance 'hir:single-value-register))
         (*next-instruction*
           (make-instance 'hir:return-instruction
             :inputs (list *target-register*))))
    (translate-ast client ast)))
