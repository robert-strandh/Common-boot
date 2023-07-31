(cl:in-package #:asdf-user)

(defsystem "common-boot-macros"
  :depends-on ("common-boot")
  :serial t
  :components
  ((:file "and")
   (:file "or")
   (:file "when")
   (:file "unless")
   (:file "cond")))
