(cl:in-package #:common-boot-hir)

;;; This instruction has no inputs.  It has a single output.  The
;;; output is a new "cell" the representation of which is not
;;; determined by this library.

(defclass make-cell-instruction (instruction)
  ())
