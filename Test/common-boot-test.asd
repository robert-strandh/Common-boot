(cl:in-package #:asdf-user)

(defsystem #:common-boot-test
  :depends-on (#:common-boot-ast-evaluator
               #:parachute)
  :serial t
  :components
  ((:file "packages")
   (:file "utilities")
   (:file "application")
   (:file "let")
   (:file "letstar")
   (:file "block-and-return-from")))
