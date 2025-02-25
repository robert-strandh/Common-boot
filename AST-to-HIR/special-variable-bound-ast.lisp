(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:special-variable-bound-ast))
  (let* ((name (ico:name ast))
         (literal (make-instance 'hir:literal :value name)))
    (make-instance 'hir:assignment-instruction
      :inputs (list literal)
      :outputs (list *target-register*)
      :successors (list *next-instruction*))))
