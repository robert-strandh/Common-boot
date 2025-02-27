(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:go-with-variable-ast))
  (let* ((variable-reference-ast (ico:variable-reference-ast ast))
         (definition-ast (ico:definition-ast variable-reference-ast))
         (index-ast (ico:index-ast ast))
         (index (ico:literal index-ast))
         (identity-register (find-register definition-ast))
         (tagbody-vector (cdr (assoc definition-ast *tagbody-vectors*))))
    (make-instance 'hir:unwind-instruction
      :origin (ico:origin ast)
      :inputs (list *dynamic-environment-register* identity-register)
      :outputs '()
      :successors (list (svref tagbody-vector index)))))
