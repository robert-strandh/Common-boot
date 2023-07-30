(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:quote-ast) environment continuation)
  ;; This seems wrong.  Fix Iconoclast.
  `(step (list ,(ico:form (ico:object-ast ast)))
         ,continuation))
