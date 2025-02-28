(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:quote-ast))
  (let* ((object-ast (ico:object-ast ast))
         (form (ico:form object-ast))
         (object (cst:raw form)))
    (multiple-value-bind (*next-instruction* *target-register*)
        (adapt-register 'hir:single-value-register)
      (make-instance 'hir:assignment-instruction
        :inputs (list (make-instance 'hir:literal
                        :origin (ico:origin ast)
                        :value object))
        :outputs (list *target-register*)
        :successors (list *next-instruction*)))))
