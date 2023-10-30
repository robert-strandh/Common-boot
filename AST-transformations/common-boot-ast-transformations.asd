(cl:in-package #:asdf-user)

(defsystem "common-boot-ast-transformations"
  :depends-on ("common-boot-ast-walker")
  :serial t
  :components
  ((:file "packages")
   (:file "client")
   (:file "canonicalize-declaration-asts")
   (:file "application-lambda-to-labels")
   (:file "function-lambda-to-labels")
   (:file "flet-to-labels")
   (:file "let-to-labels")
   (:file "letstar-to-labels")
   (:file "eliminate-special-declarations")
   (:file "lexify-lambda-list")))
