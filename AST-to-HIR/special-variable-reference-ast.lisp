(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:special-variable-bound-ast))
  (make-instance 'hir:special-variable-reference-instruction
    :variable-name (ico:name ast)
    :inputs (list *dynamic-environment-register*)
    :outputs (list *target-register*)
    :successors (list *next-instruction*)))
