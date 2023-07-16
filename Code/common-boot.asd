(cl:in-package #:asdf-user)

(defsystem #:common-boot
  :depends-on (#:common-macros
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
   (:file "environment")
   (:file "convert-ast")
   (:file "cst-to-ast")))
