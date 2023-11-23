(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client environment (ast ico:locally-ast) continuation)
  (cps-implicit-progn client environment (ico:form-asts ast) continuation))
