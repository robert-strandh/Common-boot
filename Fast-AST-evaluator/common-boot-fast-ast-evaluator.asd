(cl:in-package #:asdf-user)

(defsystem "common-boot-fast-ast-evaluator"
  :depends-on ("iconoclast"
               "iconoclast-ast-transformations"
               "common-boot")
  :serial t
  :components
  ((:file "packages")
   (:file "client")
   (:file "run-time")
   (:file "utilities")
   (:file "host-lambda-list-from-lambda-list-ast")
   (:file "find-local-functions")
   (:file "eval")
   (:file "literal")
   (:file "quote")
   (:file "application-ast")
   (:file "function-name-ast")
   (:file "variable-reference-ast")
   (:file "special-variable-reference-ast")
   (:file "progn-ast")
   (:file "block-with-variable-ast")
   (:file "labels-ast")
   (:file "if-ast")
   (:file "return-from-with-variable-ast")
   (:file "locally-ast")
   (:file "function-ast")
   (:file "multiple-value-call-ast")
   (:file "multiple-value-prog1-ast")
   (:file "the-ast")
   (:file "setq-ast")
   (:file "simple-setq-ast")
   (:file "special-variable-setq-ast")
   (:file "special-variable-bind-ast")
   (:file "progv-ast")
   (:file "tag-ast")
   (:file "catch-ast")
   (:file "throw-ast")
   (:file "macrolet-ast")
   (:file "symbol-macrolet-ast")
   (:file "tagbody-segment-ast")
   (:file "tagbody-with-variable-ast")
   (:file "go-with-variable-ast")
   (:file "eval-when-ast")
   (:file "load-time-value-ast")
   (:file "let-temporary-ast")
   (:file "make-cell-ast")
   (:file "read-cell-ast")
   (:file "write-cell-ast")
   (:file "static-environment-ast")
   (:file "set-static-environment-ast")
   (:file "read-static-environment-ast")
   (:file "local-function-ast")))
