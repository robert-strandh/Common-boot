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
   (:file "defconstant")
   (:file "defgeneric")
   (:file "define-condition")
   (:file "defmethod")
   (:file "defparameter")
   (:file "defvar")
   (:file "do")
   (:file "dostar")
   (:file "dolist")
   (:file "dotimes")
   (:file "ignore-errors")
   (:file "multiple-value-bind")
   (:file "multiple-value-list")
   (:file "multiple-value-setq")
   (:file "nth-value")))
