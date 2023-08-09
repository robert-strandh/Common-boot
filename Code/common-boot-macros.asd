(cl:in-package #:asdf-user)

(defsystem "common-boot-macros"
  :depends-on ("common-boot")
  :serial t
  :components
  ((:file "and")
   (:file "assert")
   (:file "or")
   (:file "when")
   (:file "unless")
   (:file "cond")
   (:file "case")
   (:file "ecase")
   (:file "ccase")
   (:file "check-type")
   (:file "typecase")
   (:file "etypecase")
   (:file "ctypecase")
   (:file "decf")
   (:file "incf")
   (:file "defclass")
   (:file "defconstant")
   (:file "defgeneric")
   (:file "define-compiler-macro")
   (:file "define-condition")
   (:file "define-symbol-macro")
   (:file "defmacro")
   (:file "defmethod")
   (:file "defparameter")
   (:file "deftype")
   (:file "defun")
   (:file "defvar")
   (:file "destructuring-bind")
   (:file "do")
   (:file "dostar")
   (:file "do-all-symbols")
   (:file "do-external-symbols")
   (:file "do-symbols")
   (:file "dolist")
   (:file "dotimes")
   (:file "formatter")
   (:file "handler-bind")
   (:file "handler-case")
   (:file "ignore-errors")
   (:file "lambda")
   (:file "multiple-value-bind")
   (:file "multiple-value-list")
   (:file "multiple-value-setq")
   (:file "nth-value")
   (:file "pop")
   (:file "print-unreadable-object")
   (:file "prog")
   (:file "progstar")
   (:file "prog1")
   (:file "prog2")
   (:file "psetq")
   (:file "pushnew")
   (:file "return")
   (:file "step")
   (:file "time")
   (:file "with-accessors")))
