(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client environment (ast ico:literal-ast) continuation)
  `(step (list ',(ico:literal ast)) ,continuation))
