(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client environment (ast ico:catch-ast) continuation)
  (let ((temp (gensym))
        (continuation-variable (gensym "C-")))
    `(let ((,continuation-variable
             (make-continuation
              (lambda (&rest ,temp)
                (setq ,temp (car ,temp))
                (let ((dynamic-environment dynamic-environment))
                  (push (make-instance 'catch-entry
                          :name ,temp
                          :continuation ,continuation)
                        dynamic-environment)
                  ,(cps-implicit-progn
                    client environment (ico:form-asts ast) continuation)))
              :origin ',(ico:origin ast)
              :next ,continuation)))
       ,(cps client environment (ico:tag-ast ast) continuation-variable))))
