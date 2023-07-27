(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:literal-ast) environment continuation)
  `(step (list ,(ico:literal ast)) ,continuation))
