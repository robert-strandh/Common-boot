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
   (:file "if")))
