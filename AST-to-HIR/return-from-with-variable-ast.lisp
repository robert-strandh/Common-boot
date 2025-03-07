(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:return-from-with-variable-ast))
  (let* ((variable-reference-ast (ico:variable-reference-ast ast))
         (definition-ast (ico:definition-ast variable-reference-ast))
         (identity-register (find-register definition-ast))
         (form-ast (if (null (ico:form-ast ast))
                       (make-instance 'ico:literal-ast
                         :origin (ico:origin ast)
                         :literal nil)
                       (ico:form-ast ast)))
         (block-target-register *block-target-register*)
         (*target-register*
           (if (null block-target-register)
               nil
               (make-instance (class-of block-target-register))))
         (*next-instruction*
           (make-instance 'hir:unwind-instruction
             :origin (ico:origin ast)
             :inputs (list* *dynamic-environment-register*
                            identity-register
                            (if (null *target-register*) 
                                '()
                                (list *target-register*)))
             :outputs '()
             :successors (list *block-receive-instruction*))))
    (translate-ast client form-ast)))
