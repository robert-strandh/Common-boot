(cl:in-package #:common-boot-hir)

;;; This instructin has three inputs, no outputs, and no successors.
;;; The first input is a dynamic-environment object.  The second input
;;; is a catch tag.  The third input is the list of values to be
;;; thrown.

(defclass throw-instruction (instruction)
  ())
