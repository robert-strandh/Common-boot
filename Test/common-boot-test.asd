(cl:in-package #:asdf-user)

(defsystem #:common-boot-test
  :depends-on (#:common-boot-ast-evaluator
               #:parachute)
  :serial t
  :components
  ((:file "packages")
   (:file "utilities")
   (:file "quote")
   (:file "application")
   (:file "if")
   (:file "let")
   (:file "letstar")
   (:file "locally")
   (:file "flet")
   (:file "labels")
   (:file "block-and-return-from")
   (:file "catch-and-throw")))
