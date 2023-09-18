(cl:in-package #:asdf-user)

(defsystem "common-boot-ast-transformations"
  :depends-on ("common-boot-ast-walker")
  :serial t
  :components
  ((:file "packages")
   (:file "client")
   (:file "canonicalize-declaration-asts")))
