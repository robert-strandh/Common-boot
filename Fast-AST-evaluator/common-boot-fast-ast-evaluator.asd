(cl:in-package #:asdf-user)

(defsystem "common-boot-fast-ast-evaluator"
  :depends-on ("iconoclast"
               "iconoclast-ast-transformations"
               "common-boot")
  :serial t
  :components
  ((:file "packages")
   (:file "run-time")
   (:file "utilities")
   (:file "host-lambda-list-from-lambda-list-ast")
   (:file "eval")
   (:file "literal")
   (:file "quote")
   (:file "application-ast")
   (:file "function-name-ast")
   (:file "variable-reference-ast")
   (:file "progn-ast")
   (:file "block-ast")
   (:file "labels-ast")
   (:file "if-ast")
   (:file "return-from-ast")))
