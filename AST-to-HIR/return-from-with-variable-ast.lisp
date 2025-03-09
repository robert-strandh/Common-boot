(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:return-from-with-variable-ast))
  (let* ((variable-reference-ast (ico:variable-reference-ast ast))
         (variable-definition-ast
           (ico:definition-ast variable-reference-ast))
         (block-reference-ast (ico:name-ast ast))
         (block-definition-ast
           (ico:block-name-definition-ast block-reference-ast))
         (identity-register (find-register variable-definition-ast))
         (form-ast (if (null (ico:form-ast ast))
                       (make-instance 'ico:literal-ast
                         :origin (ico:origin ast)
                         :literal nil)
                       (ico:form-ast ast)))
         (block-target-register
           (cdr (assoc block-definition-ast *block-target-register*)))
         (block-receive-instruction
           (cdr (assoc block-definition-ast *block-receive-instruction*)))
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
             :successors (list block-receive-instruction))))
    (translate-ast client form-ast)))
