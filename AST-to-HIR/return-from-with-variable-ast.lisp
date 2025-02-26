(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:return-from-with-variable-ast))
  (let* ((variable-reference-ast (ico:variable-reference-ast ast))
         (definition-ast (ico:definition-ast variable-reference-ast))
         (identity-register (find-register definition-ast))
         (form-ast (ico:form-ast ast))
         (block-target-register *block-target-register*)
         (*target-register*
           (if (null block-target-register)
               nil
               (make-instance (class-of block-target-register))))
         (*next-instruction*
           (make-instance 'hir:unwind-instruction
             :inputs (list *dynamic-environment-register*
                           identity-register
                           *target-register*)
             :outputs '()
             :successors (list *block-receive-instruction*))))
    (translate-ast client form-ast)))
