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
   (:file "environment")
   (:file "cst-to-ast")))
