(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:catch-ast) continuation)
  (let ((temp (gensym))
        (continuation-variable (gensym "C-")))
    `(let ((,continuation-variable
             (lambda (&rest ,temp)
               (setq ,temp (car ,temp))
               (let ((dynamic-environment dynamic-environment))
                 (push (make-instance 'catch-entry
                         :name ,temp
                         :continuation ,continuation
                         :stack *stack*)
                       dynamic-environment)
                 ,(cps-implicit-progn
                   client (ico:form-asts ast) continuation)))))
       ,(cps client (ico:tag-ast ast) continuation-variable))))
