(cl:in-package #:asdf-user)

(defsystem #:common-boot
  :depends-on (#:concrete-syntax-tree
               #:common-macros
               #:clostrum
               #:clostrum-basic
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
   (:file "convert")
   (:file "convert-ast")
   (:file "cst-to-ast")))
