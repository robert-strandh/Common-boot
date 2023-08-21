(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:locally-ast) continuation)
  (cps-implicit-progn client (ico:form-asts ast) continuation))
