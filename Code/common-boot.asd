(cl:in-package #:asdf-user)

(defsystem #:common-boot
  :depends-on (#:common-macros-mop-package
               #:common-macros
               #:clostrum
               #:clostrum-basic)
  :serial t
  :components
  ((:file "packages")
   (:file "main")))
