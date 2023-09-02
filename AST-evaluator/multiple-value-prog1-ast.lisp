(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:multiple-value-prog1-ast) continuation)
  (cps client
       (ico:values-ast ast)
       `(lambda (&rest values)
          ,(cps-implicit-progn
            client
            (ico:form-asts ast)
            `(lambda (&rest ignore)
               (declare (ignore ignore))
               (step values ,continuation))))))
