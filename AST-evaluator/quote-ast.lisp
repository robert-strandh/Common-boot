(cl:in-package #:common-boot-ast-evaluator)

;;; The use of CST:RAW seems wrong here. 
(defmethod cps (client environment (ast ico:quote-ast) continuation)
  `(step (list ',(cst:raw (ico:form (ico:object-ast ast))))
         ,continuation))
