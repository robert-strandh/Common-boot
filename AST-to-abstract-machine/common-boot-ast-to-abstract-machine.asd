(cl:in-package #:asdf-user)

(defsystem "common-boot-ast-to-abstract-machine"
  :depends-on ("iconoclast"
               "iconoclast-ast-transformations"
               "common-boot")
  :serial t
  :components
  ((:file "packages")
   (:file "context")
   (:file "utilities")
   (:file "translate")
   (:file "progn-ast")
   (:file "let-temporary-ast")
   (:file "literal-ast")
   (:file "variable-reference-ast")
   (:file "if-ast")
   (:file "application-ast")
   (:file "make-cell-ast")))
