(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:literal-ast))
  (let ((literal (ico:literal ast)))
    (if (null *target-register*)
        *next-instruction*
        (make-instance 'hir:assignment-instruction
          :inputs (list (make-instance 'hir:literal :value literal))
          :outputs (list *target-register*)
          :successors (list *next-instruction* )))))
