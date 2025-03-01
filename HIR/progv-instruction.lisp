(cl:in-package #:common-boot-hir)

;;; This instruction has three inputs and one output.  The first input
;;; is a dynamic-environment object.  The second input is a list of
;;; symbols to be bound.  The third input is a list of values for the
;;; variables to be bound to.  The output is a dynamic-environment
;;; object.

(defclass progv-instruction (instruction)
  ())
