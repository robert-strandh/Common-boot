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
               #:common-macros)
  :serial t
  :components
  ((:file "packages")
   (:file "variables")
   (:file "generic-functions")
   (:file "builder")
   (:file "environment")
   (:file "environment-query")
   (:file "environment-augmentation")
   (:file "application")
   (:file "lambda-list")
   (:file "let")
   (:file "flet")
   (:file "labels")
   (:file "letstar")
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
   (:file "the")
   (:file "unwind-protect")
   (:file "convert-variable")
   (:file "convert-constant")
   (:file "convert-with-description")
   (:file "convert")
   (:file "convert-ast")
   (:file "cst-to-ast")))
