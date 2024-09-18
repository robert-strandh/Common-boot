(cl:in-package #:asdf-user)

(defsystem "common-boot-ast-interpreter-test"
  :depends-on ("common-boot"
               "common-boot-ast-interpreter"
               "parachute")
  :serial t
  :components
  ((:file "packages")
   (:file "configuration")
   (:file "utilities")
   (:file "quote")
   (:file "application")
   (:file "if")
   (:file "block-and-return-from")
   (:file "labels")
   (:file "function")
   (:file "flet")
   (:file "let")
   (:file "letstar")
   (:file "locally")
   (:file "progn")
   (:file "the")
   (:file "multiple-value-call")
   (:file "multiple-value-prog1")
   (:file "setq")
   (:file "progv")
   (:file "catch-and-throw")
   (:file "macrolet")
   (:file "symbol-macrolet")
   (:file "tagbody-and-go")
   (:file "special-variable")))
