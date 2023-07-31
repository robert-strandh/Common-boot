(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:catch-ast) environment continuation)
  (let ((temp (gensym)))
    (cps client
         (ico:tag-ast ast)
         environment
         `(lambda (&rest ,temp)
            (setq ,temp (car ,temp))
            (push (make-instance 'catch-entry
                    :tag ,temp
                    :continuation ,continuation
                    :stack *stack*)
                  *dynamic-environment*)
            ,(cps-implicit-progn
              client (ico:form-asts ast) environment continuation)))))
