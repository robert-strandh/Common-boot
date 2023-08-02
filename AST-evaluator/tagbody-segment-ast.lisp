(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps
    (client (ast ico:tagbody-segment-ast) environment continuation)
  (let ((temp (gensym))
        (action `(step '() ,continuation)))
    (loop for statement-ast in (reverse (ico:statement-asts ast))
          do (setf action
                   (cps client
                        statement-ast
                        environment
                        `(lambda (&rest ,temp)
                           (declare (ignore ,temp))
                           ,action))))))