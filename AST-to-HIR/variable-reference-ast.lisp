(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:variable-reference-ast))
  (let* ((variable-definition-ast (ico:definition-ast ast))
         (register (find-register variable-definition-ast)))
    (multiple-value-bind (*next-instruction* *target-register*)
        (adapt-register 'hir:single-value-register)
      (make-instance 'hir:assignment-instruction
        :inputs (list register)
        :outputs (list *target-register*)
        :successors (list *next-instruction*)))))
