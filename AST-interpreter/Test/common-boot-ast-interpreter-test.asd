(cl:in-package #:asdf-user)

(defsystem "common-boot-ast-interpreter-test"
  :depends-on ("common-boot"
               "common-boot-ast-interpreter"
               "parachute")
  :serial t
  :components
  ((:file "packages")))
