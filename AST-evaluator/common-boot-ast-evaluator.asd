(cl:in-package #:asdf-user)

(defsystem #:common-boot-ast-evaluator
  :depends-on (#:closer-mop
               #:common-boot)
  :serial t
  :components
  ((:file "packages")
   (:file "generic-functions")
   (:file "utilities")
   (:file "run-time")
   (:file "convert")
   (:file "literal-ast")
   (:file "variable-name-ast")
   (:file "function-name-ast")
   (:file "progn-ast")
   (:file "let-and-letstar-ast")
   (:file "block-ast")
   (:file "return-from")
   (:file "application-ast")
   (:file "ast-to-cps")))
