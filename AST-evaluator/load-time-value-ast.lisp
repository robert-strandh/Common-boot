(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps
    (client environment (ast ico:load-time-value-ast) continuation)
  `(step (list ,(ico:form-ast ast))
         ,continuation))
