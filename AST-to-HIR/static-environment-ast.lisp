(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:static-environment-ast))
  (make-instance 'hir:assignment-instruction
    :inputs (list *static-environment-register*)
    :outputs (list *target-register*)
    :successors (list *next-instruction*)))
