(cl:in-package #:asdf-user)

(defsystem "common-boot-ast-transformations-test"
  :depends-on ("common-boot-ast-transformations"
               "iconoclast-builder"
               "parachute")
  :serial t
  :components
  ((:file "packages")
   (:file "utilities")
   (:file "configuration")
   (:file "lexify-lambda-list")))
