(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:tag-ast) environment continuation)
  `(step (list ,(ico:name ast))
         ,continuation))
