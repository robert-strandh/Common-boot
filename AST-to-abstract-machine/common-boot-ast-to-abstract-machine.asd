(cl:in-package #:asdf-user)

(defsystem "common-boot-ast-to-abstract-machine"
  :depends-on ("iconoclast"
               "iconoclast-ast-transformations"
               "common-boot")
  :serial t
  :components
  ((:file "packages")))
