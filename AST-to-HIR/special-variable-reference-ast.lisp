(cl:in-package #:common-boot-ast-to-hir)

;;; It is possible that the target register is a multiple-value
;;; register.  If that is the case, we do not want to assign a single
;;; value to it.  To fix this problem, we create an intermediate
;;; assignment instruction which is designed to handle assignments
;;; between single and multiple value registers.

(defmethod translate-ast (client (ast ico:special-variable-reference-ast))
  (let* ((register (make-instance 'hir:single-value-register))
         (assignment-instruction
           (make-instance 'hir:assignment-instruction
             :inputs (list register)
             :outputs (list *target-register*)
             :successors (list *next-instruction*))))
    (make-instance 'hir:special-variable-reference-instruction
      :variable-name (ico:name ast)
      :inputs (list *dynamic-environment-register*)
      :outputs (list register)
      :successors (list assignment-instruction))))
