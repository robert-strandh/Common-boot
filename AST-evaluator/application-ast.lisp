(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client environment (ast ico:application-ast) continuation)
  (let* ((argument-asts (ico:argument-asts ast))
         (function-variable (gensym "FUN-"))
         (argument-variables
           (loop for argument-ast in argument-asts
                 collect (gensym "ARG-")))
         (name (gensym "C-")))
    `(let ,(cons function-variable argument-variables)
       (let* ((,name
                (lambda (&rest ignore)
                  (declare (ignore ignore))
                  (step (multiple-value-list
                         (apply ,function-variable
                                (list ,@argument-variables)))
                        ,continuation)))
              ,@(loop for argument-ast in (reverse argument-asts)
                      for argument-variable in (reverse argument-variables)
                      when (typep argument-ast 'ico:variable-reference-ast)
                        collect
                        (let* ((definition-ast
                                 (ico:variable-definition-ast argument-ast))
                               (host-variable (lookup definition-ast)))
                          `(,name (lambda (&rest ignore)
                                    (declare (ignore ignore))
                                    (setq ,argument-variable
                                          (car ,host-variable))
                                    (step nil ,name))))
                      unless (typep argument-ast 'ico:variable-reference-ast)
                        collect `(,name (lambda (&rest var)
                                          (setq ,argument-variable (car var))
                                          (step nil ,name)))
                      unless (typep argument-ast 'ico:variable-reference-ast)
                        collect `(,name (lambda (&rest ignore)
                                          (declare (ignore ignore))
                                          ,(cps client environment
                                                argument-ast
                                                name))))
              (,name (lambda (&rest var)
                       (setf ,function-variable (car var))
                       (step nil ,name))))
         (setq *dynamic-environment* dynamic-environment)
         ,(cps client environment
               (ico:function-name-ast ast)
               name)))))
