(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:if-ast))
  (let* ((test-ast (ico:test-ast ast))
         (then-ast (ico:then-ast ast))
         (else-ast (ico:else-ast ast))
         (register (make-instance 'hir:single-value-register))
         (then-instruction
           (translate-ast client then-ast))
         (else-instruction
           (translate-ast client
                          (if (null else-ast)
                              (make-instance 'ico:literal-ast :literal nil)
                              else-ast)))
         (if-instruction
           (make-instance 'hir:if-instruction
             :origin (ico:origin ast)
             :inputs (list register)
             :outputs '()
             :successors (list then-instruction else-instruction))))
    (let ((*target-register* register)
          (*next-instruction* if-instruction))
      (translate-ast client test-ast))))
