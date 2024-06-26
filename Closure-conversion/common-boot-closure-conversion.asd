(cl:in-package #:asdf-user)

(defsystem "common-boot-closure-conversion"
  :depends-on ("common-boot"
               "iconoclast-ast-walker")
  :serial t
  :components
  ((:file "packages")
   (:file "function-tree")))
