(cl:in-package #:asdf-user)

(defsystem #:common-boot-ast-evaluator
  :depends-on (#:closer-mop
               #:common-boot)
  :serial t
  :components
  ((:file "packages")
   (:file "generic-functions")
   (:file "utilities")
   (:file "run-time")
   (:file "convert")
   (:file "function-name-ast")
   (:file "application-ast")
   (:file "ast-to-cps")))
