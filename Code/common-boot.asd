(cl:in-package #:asdf-user)

(defsystem #:common-boot
  :depends-on (#:concrete-syntax-tree
               #:s-expression-syntax.concrete-syntax-tree
               #:common-macros
               #:clostrum
               #:clostrum-basic
               #:clostrum-trucler
               #:trucler-reference
               #:iconoclast-builder
               #:common-macros
               #:common-boot-ast-evaluator)
  :serial t
  :components
  ((:file "packages")
   (:file "variables")
   (:file "generic-functions")
   (:file "utilities")
   (:file "builder")
   (:file "environment")
   (:file "environment-query")
   (:file "finalize-name-reference")
   (:file "environment-augmentation")
   (:file "declarations")
   (:file "application")
   (:file "function")
   (:file "lambda-list")
   (:file "let")
   (:file "flet")
   (:file "labels")
   (:file "letstar")
   (:file "locally")
   (:file "progn")
   (:file "block")
   (:file "return-from")
   (:file "catch")
   (:file "throw")
   (:file "eval-when")
   (:file "tagbody")
   (:file "go")
   (:file "if")
   (:file "load-time-value")
   (:file "multiple-value-call")
   (:file "multiple-value-prog1")
   (:file "progv")
   (:file "quote")
   (:file "setq")
   (:file "the")
   (:file "unwind-protect")
   (:file "convert-variable")
   (:file "convert-constant")
   (:file "convert-with-description")
   (:file "convert")
   (:file "convert-ast")
   (:file "cst-to-ast")
   (:file "eval")))
