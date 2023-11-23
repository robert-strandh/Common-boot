(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps
    (client environment (ast ico:tagbody-segment-ast) continuation)
  (cps-implicit-progn client environment (ico:statement-asts ast) continuation))
