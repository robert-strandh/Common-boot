(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps
    (client (ast ico:tagbody-segment-ast) continuation)
  (cps-implicit-progn client (ico:statement-asts ast) continuation))
