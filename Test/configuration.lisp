(cl:in-package #:common-boot-test)

(defclass client (trucler-reference:client)
  ())

(defmethod cb:convert-with-parser-p ((client client) operator)
  (special-operator-p operator))
