(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:special-variable-bind-ast) continuation)
  (let ((variable-name-ast (ico:variable-name-ast ast))
        (form-ast (ico:form-ast ast))
        (form-asts (ico:form-asts ast))
        (variable-name (gensym))
        (continuation-variable (gensym "C-")))
    `(let ((,continuation-variable
             (lambda (&rest ,variable-name)
               (setf ,variable-name (car ,variable-name))
               (let ((dynamic-environment dynamic-environment))
                 (push (make-instance 'special-variable-entry
                         :name ,(ico:name variable-name-ast)
                         :value ,variable-name)
                       dynamic-environment)
                 ,(cps-implicit-progn client form-asts continuation)))))
       ,(cps client form-ast continuation-variable))))

