(cl:in-package #:asdf-user)

(defsystem "common-boot-ast-to-hir"
  :depends-on ("iconoclast"
               "iconoclast-ast-transformations"
               "common-boot-hir")
  :serial t
  :components
  ((:file "packages")
   (:file "context")
   (:file "registers")
   (:file "translate")
   (:file "literal-ast")
   (:file "variable-reference-ast")
   (:file "progn-ast")
   (:file "application-ast")
   (:file "let-temporary-ast")
   (:file "set-static-environment-ast")
   (:file "read-static-environment-ast")
   (:file "tagbody-with-variable-ast")
   (:file "go-with-variable-ast")
   (:file "block-with-variable-ast")
   (:file "return-from-with-variable-ast")
   (:file "special-variable-bind-ast")
   (:file "global-function-name-reference-ast")
   (:file "local-function-ast")
   (:file "labels-ast")
   (:file "ast-to-hir")))
