(cl:in-package #:common-boot-hir)

;;; This instruction has a single input which is a
;;; MULTIPLE-VALUE-REGISTER.  It has no successors.

(defclass return-instruction (instruction)
  ())
