(cl:in-package #:common-boot-hir)

;;; This instruction has two inputs.  The first input is a
;;; dynamic-environment object.  The second input is the value to
;;; assign.  This instruction has one output which is the new value of
;;; the special variable.

(defclass special-variable-setq-instruction (instruction)
  ((%variable-name
    :initarg :variable-name
    :reader variable-name)))
