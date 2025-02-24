(cl:in-package #:common-boot-hir-evaluator-test)

(defclass client (trucler-reference:client cbhe:client)
  ())

(defmethod cb:convert-with-parser-p ((client client) operator)
  (special-operator-p operator))

(defmethod cb:convert-with-ordinary-macro-p ((client client) operator)
  (cmd:macro-function-exists-p operator))
