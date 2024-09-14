(cl:in-package #:asdf-user)

(defsystem "common-boot-ast-interpreter"
  :depends-on ("iconoclast"
               "iconoclast-ast-transformations")
  :serial t
  :components
  ((:file "packages")))
