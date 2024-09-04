(cl:in-package #:asdf-user)

(defsystem "common-boot-fast-ast-evaluator"
  :depends-on ("iconoclast")
  :serial t
  :components
  ((:file "packages")
   (:file "application-ast")))
