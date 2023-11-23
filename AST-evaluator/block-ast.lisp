(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client environment (ast ico:block-ast) continuation)
  (let ((name (gensym "BLOCK"))
        (temp (gensym))
        (continuation-variable (gensym "C-")))
    (setf (lookup (ico:name-ast ast)) name)
    `(let ((dynamic-environment dynamic-environment))
       (push (make-instance 'block-entry
               :continuation ,continuation
               :name ',name)
             dynamic-environment)
       (let ((,continuation-variable
               (lambda (&rest ,temp)
                 (setf continuation ,continuation))))
         ,(cps-implicit-progn
           client environment (ico:form-asts ast) continuation-variable)))))
