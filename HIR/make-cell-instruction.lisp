(cl:in-package #:common-boot-hir)

;;; This instruction has one input.  The input is a value to be stored
;;; in the cell created by this instruction.  It has a single output.
;;; The output is a new "cell" the representation of which is not
;;; determined by this library.

(defclass make-cell-instruction (instruction)
  ())
