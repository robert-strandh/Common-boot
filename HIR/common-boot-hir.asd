(cl:in-package #:asdf-user)

(defsystem "common-boot-hir"
  :depends-on ()
  :serial t
  :components
  ((:file "packages")
   (:file "instruction")
   (:file "data")
   (:file "parse-arguments-instruction")
   (:file "nop-instruction")
   (:file "make-cell-instruction")
   (:file "read-cell-instruction")
   (:file "write-cell-instruction")
   (:file "set-static-environment-instruction")
   (:file "dynamic-environment-instruction")
   (:file "read-static-environment-instruction")
   (:file "if-instruction")
   (:file "exit-point-instruction")
   (:file "unwind-instruction")
   (:file "receive-instruction")
   (:file "funcall-instruction")
   (:file "multiple-value-call-instruction")
   (:file "return-instruction")
   (:file "assignment-instruction")
   (:file "progv-instruction")
   (:file "special-variable-binding-instruction")
   (:file "special-variable-bound-instruction")
   (:file "global-function-reference-instruction")
   (:file "special-variable-reference-instruction")
   (:file "special-variable-setq-instruction")
   (:file "enclose-instruction")
   (:file "catch-instruction")
   (:file "throw-instruction")))
