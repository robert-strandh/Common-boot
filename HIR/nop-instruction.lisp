(cl:in-package #:common-boot-hir)

;;; This instruction has no inputs and no outputs.  It does nothing.

(defclass nop-instruction (instruction)
  ())
