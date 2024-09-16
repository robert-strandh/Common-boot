(cl:in-package #:asdf-user)

(defsystem "common-boot-ast-interpreter"
  :depends-on ("iconoclast"
               "iconoclast-ast-transformations"
               "common-boot")
  :serial t
  :components
  ((:file "packages")
   (:file "client")
   (:file "run-time")
   (:file "eval")
   (:file "literal-ast")
   (:file "quote-ast")
   (:file "progn-ast")
   (:file "function-reference-ast")
   (:file "global-function-name-ast")
   (:file "variable-reference-ast")
   (:file "application-ast")
   (:file "block-ast")
   (:file "return-from-ast")
   (:file "labels-ast")
   (:file "locally-ast")
   (:file "if-ast")))
