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
   (:file "introduce-cells")
   (:file "eval")
   (:file "literal-ast")
   (:file "quote-ast")
   (:file "progn-ast")
   (:file "function-reference-ast")
   (:file "global-function-name-ast")
   (:file "global-function-cell-ast")
   (:file "variable-reference-ast")
   (:file "application-ast")
   (:file "block-ast")
   (:file "return-from-ast")
   (:file "labels-ast")
   (:file "locally-ast")
   (:file "if-ast")
   (:file "function-ast")
   (:file "the-ast")
   (:file "multiple-value-call-ast")
   (:file "multiple-value-prog1-ast")
   (:file "setq-ast")
   (:file "simple-setq-ast")
   (:file "special-variable-setq-ast")
   (:file "special-variable-reference-ast")
   (:file "special-variable-bind-ast")
   (:file "progv-ast")
   (:file "tag-ast")
   (:file "catch-ast")
   (:file "throw-ast")
   (:file "macrolet-ast")
   (:file "symbol-macrolet-ast")
   (:file "tagbody-segment-ast")
   (:file "tagbody-ast")
   (:file "go-ast")
   (:file "eval-when-ast")
   (:file "load-time-value-ast")))
