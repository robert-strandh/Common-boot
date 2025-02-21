(cl:in-package #:common-boot-hir)

;;; This instruction has two inputs and one output.  The first input
;;; is a static-environment object and the second input is a literal
;;; non-negative integer that indicates the entry number in the static
;;; environment to read.  The output is the contents of that entry in
;;; the static-environment object.

(defclass read-static-environment-instruction (instruction)
  ())
