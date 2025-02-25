(cl:in-package #:common-boot-hir)

;;; This instruction has two inputs and one output.  The first input
;;; is a dynamic-environment object.  The second input is the name of
;;; a special variable.  The output is the value of that special
;;; variable in the dynamic environment.

(defclass special-variable-bound-instruction (instruction)
  ((%variable-name
    :initarg :variable-name
    :reader variable-name)))
