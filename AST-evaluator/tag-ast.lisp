(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client environment (ast ico:tag-ast) continuation)
  `(step (list ,(cst:raw (ico:name ast)))
         ,continuation))
