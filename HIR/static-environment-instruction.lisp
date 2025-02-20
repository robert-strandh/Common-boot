(cl:in-package #:common-boot-hir)

;;; This instruction has no inputs and one output.  The output is the
;;; static environment for the currently-executing function.

(defclass static-environment-instruction (instruction)
  ())
