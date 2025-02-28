(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:literal-ast))
  (let ((literal (ico:literal ast)))
    (multiple-value-bind (*next-instruction* *target-register*)
        (adapt-register 'hir:single-value-register)
      (make-instance 'hir:assignment-instruction
        :inputs (list (make-instance 'hir:literal
                        :origin (ico:origin ast)
                        :value literal))
        :outputs (list *target-register*)
        :successors (list *next-instruction*)))))
