(cl:in-package #:asdf-user)

(defsystem "common-boot-fast-ast-evaluator"
  :depends-on ("iconoclast"
               "common-boot")
  :serial t
  :components
  ((:file "packages")
   (:file "run-time")
   (:file "eval")
   (:file "quote")
   (:file "application-ast")
   (:file "function-name-ast")
   (:file "progn-ast")))
