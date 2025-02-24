(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:quote-ast))
  (let* ((object-ast (ico:object-ast ast))
         (form-ast (ico:form-ast object-ast))
         (object (cst:raw form-ast)))
    (make-instance 'hir:assignment-instruction
      :inputs (list (make-instance 'hir:literal :value object))
      :outputs (list *target-register*)
      :successors (list *next-instruction* ))))
