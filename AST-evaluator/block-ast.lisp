(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:block-ast) continuation)
  (let ((name (gensym "BLOCK"))
        (temp (gensym)))
    (setf (lookup (ico:name-ast ast)) name)
    `(let ((dynamic-environment dynamic-environment))
       (push (make-instance 'block-entry
               :continuation ,continuation
               :stack *stack*
               :name ',name)
             dynamic-environment)
       ,(cps-implicit-progn
                client
                (ico:form-asts ast)
                `(lambda (&rest ,temp)
                   (pop-stack)
                   ,continuation)))))
