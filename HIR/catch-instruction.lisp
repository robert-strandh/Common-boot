(cl:in-package #:common-boot-hir)

;;; This instruction has two inputs, two outputs, and two successors.
;;; The first input is a dynamic-environment object. The second input
;;; is the catch tag.  The first output is a dynamic-environment
;;; object.  The second output is the target register for the CATCH
;;; form.  The first successor is the first instruction of the body of
;;; the CATCH form.  That successor is used when the CATCH instruction
;;; is entered normally.  The second successor is the successor of the
;;; CATCH form.  That successor is used when the CATCH form is entered
;;; through a THROW.

(defclass catch-instruction (instruction)
  ())
