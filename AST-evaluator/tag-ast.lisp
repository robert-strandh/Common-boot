(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:tag-ast) continuation)
  `(step (list ,(ico:name ast))
         ,continuation))
