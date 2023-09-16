(cl:in-package #:common-boot-ast-evaluator)

;;; For now, treat eval-when as PROGN
(defmethod cps (client (ast ico:eval-when-ast) continuation)
  (cps-implicit-progn client (ico:form-asts ast) continuation))
