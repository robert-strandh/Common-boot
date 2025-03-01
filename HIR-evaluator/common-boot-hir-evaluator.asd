(cl:in-package #:asdf-user)

;;; This system was originally written by Marco Heisig for SICL.
;;; Robert Strandh adapted it to a simplified version of HIR. and
;;; extracted it to the Common boot repository.

(defsystem "common-boot-hir-evaluator"
  :depends-on ("common-boot-hir"
               "common-boot-ast-to-hir"
               "closer-mop")
  :serial t
  :components
  ((:file "packages")
   (:file "client")
   (:file "utilities")
   (:file "lexical-environment")
   (:file "run-time")
   (:file "eval")
   (:file "evaluator")
   (:file "make-thunk")
   (:file "parse-arguments-instruction")
   (:file "nop-instruction")
   (:file "global-function-reference-instruction")
   (:file "funcall-instruction")
   (:file "multiple-value-call-instruction")
   (:file "enclose-instruction")
   (:file "if-instruction")
   (:file "assignment-instruction")
   (:file "read-static-environment-instruction")
   (:file "set-static-environment-instruction")
   (:file "exit-point-instruction")
   (:file "unwind-instruction")
   (:file "receive-instruction")
   (:file "special-variable-binding-instruction")
   (:file "special-variable-reference-instruction")
   (:file "special-variable-setq-instruction")
   (:file "return-instruction")
   (:file "make-cell-instruction")
   (:file "read-cell-instruction")
   (:file "write-cell-instruction")))
