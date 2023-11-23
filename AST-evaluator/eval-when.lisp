(cl:in-package #:common-boot-ast-evaluator)

;;; For now, treat eval-when as PROGN
(defmethod cps (client environment (ast ico:eval-when-ast) continuation)
  (cps-implicit-progn client environment (ico:form-asts ast) continuation))
