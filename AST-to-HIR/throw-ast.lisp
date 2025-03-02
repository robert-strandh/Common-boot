(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:throw-ast))
  (let* ((tag-register
           (make-instance 'hir:single-value-register
             :name "catch tag"))
         (values-register
           (make-instance 'hir:multiple-value-register
             :name "throw values"))
         (*next-instruction*
           (make-instance 'hir:throw-instruction
             :inputs (list *dynamic-environment-register*
                           tag-register
                           values-register)
             :outputs '()
             :successors '()))
         (*target-register* values-register)
         (*next-instruction*
           (translate-ast client (ico:form-ast ast)))
         (*target-register* tag-register))
    (translate-ast client (ico:tag-form-ast ast))))
