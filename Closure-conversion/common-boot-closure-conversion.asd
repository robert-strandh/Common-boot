(cl:in-package #:asdf-user)

(defsystem "common-boot-closure-conversion"
  :depends-on ("common-boot")
  :serial t
  :components
  ((:file "packages")))
