(cl:in-package #:asdf-user)

(defsystem "common-boot-ast-to-hir-test"
  :depends-on ("common-boot-ast-to-hir"
               "common-boot")
  :serial t
  :components
  ((:file "packages")
   (:file "configuration")
   (:file "utilities")))
