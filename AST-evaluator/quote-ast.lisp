(cl:in-package #:common-boot-ast-evaluator)

;;; The use of CST:RAW seems wrong here. 
(defmethod cps (client (ast ico:quote-ast) environment continuation)
  `(step (list ',(cst:raw (ico:object-ast ast)))
         ,continuation))
