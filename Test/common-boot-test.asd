(cl:in-package #:asdf-user)

(defsystem #:common-boot-test
  :depends-on (#:common-boot
               #:common-boot-ast-evaluator
               #:parachute)
  :serial t
  :components
  ((:file "packages")
   (:file "configuration")
   (:file "utilities")
   (:file "quote")
   (:file "application")
   (:file "if")
   (:file "let")
   (:file "letstar")
   (:file "locally")
   (:file "flet")
   (:file "labels")
   (:file "multiple-value-call")
   (:file "block-and-return-from")
   (:file "catch-and-throw")
   (:file "progn")
   (:file "the")
   (:file "setq")
   (:file "multiple-value-prog1")
   (:file "function")
   (:file "tagbody-and-go")
   (:file "symbol-macrolet")))
