(cl:in-package #:asdf-user)

(defsystem "common-boot-macros"
  :depends-on ("common-boot")
  :serial t
  :components
  ((:file "and")
   (:file "or")
   (:file "when")
   (:file "unless")
   (:file "cond")
   (:file "case")
   (:file "ecase")
   (:file "ccase")
   (:file "check-type")
   (:file "decf")
   (:file "incf")
   (:file "defclass")
   (:file "defconstant")))
