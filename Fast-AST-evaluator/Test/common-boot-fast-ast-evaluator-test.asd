(cl:in-package #:asdf-user)

(defsystem #:common-boot-fast-ast-evaluator-test
  :depends-on (#:common-boot
               #:common-boot-fast-ast-evaluator
               #:parachute)
  :serial t
  :components
  ((:file "packages")
   (:file "configuration")
   (:file "utilities")
   (:file "quote")
   (:file "application")
   (:file "if")
   (:file "block-and-return-from")
   (:file "multiple-value-call")
   (:file "the")
   (:file "flet")
   (:file "function")
   (:file "labels")
   (:file "let")
   (:file "letstar")
   (:file "locally")))
