(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client environment (ast ico:special-variable-bind-ast) continuation)
  (let* ((binding-ast (ico:binding-ast ast))
         (variable-name-ast (ico:variable-name-ast binding-ast))
         (form-ast (ico:form-ast binding-ast))
         (form-asts (ico:form-asts ast))
         (temp (gensym))
         (continuation-variable (gensym "C-")))
    `(let ((,continuation-variable
             (make-before-continuation
              (lambda (&rest ,temp)
                (setf ,temp (car ,temp))
                (let ((dynamic-environment dynamic-environment))
                  (push (make-instance 'special-variable-entry
                          :name ',(ico:name variable-name-ast)
                          :value ,temp)
                        dynamic-environment)
                  ,(cps-implicit-progn
                    client environment form-asts continuation)))
              :origin ',(ico:origin ast)
              :next ,continuation)))
       ,(cps client environment form-ast continuation-variable))))

