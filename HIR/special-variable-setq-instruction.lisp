(cl:in-package #:common-boot-hir)

;;; This instruction has two inputs.  The first input is a symbol
;;; naming the special variable to assign to.  The second input is the
;;; value to assign.  This instruction has no outputs.

(defclass special-variable-setq-instruction (instruction)
  ())
