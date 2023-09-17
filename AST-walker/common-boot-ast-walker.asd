(cl:in-package #:asdf-user)

(defsystem "common-boot-ast-walker"
  :depends-on ("iconoclast")
  :serial t
  :components
  ((:file "packages")
   (:file "generic-functions")))

