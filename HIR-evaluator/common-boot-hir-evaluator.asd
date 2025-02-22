(cl:in-package #:asdf-user)

;;; This system was originally written by Marco Heisig for SICL.
;;; Robert Strandh adapted it to a simplified version of HIR. and
;;; extracted it to the Common boot repository.

(defsystem "common-boot-hir-evaluator"
  :depends-on ("common-boot-hir"
               "closer-mop")
  :serial t
  :components
  ((:file "packages")
   (:file "utilities")
   (:file "lexical-environment")
   (:file "run-time")
   (:file "evaluator")
   (:file "make-thunk")
   (:file "parse-arguments-instruction")
   (:file "enclose-instruction")
   (:file "if-instruction")
   (:file "assignment-instruction")))
