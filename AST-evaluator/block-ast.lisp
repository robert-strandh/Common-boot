(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:block-ast) environment continuation)
  `(progn (push (make-instance 'block-entry
                  :name ',(ico:name (ico:name-ast ast))
                  :continuation ,continuation)
                *dynamic-environment*)
          ,(cps-implicit-progn
            client (ico:form-asts ast) environment continuation)))
