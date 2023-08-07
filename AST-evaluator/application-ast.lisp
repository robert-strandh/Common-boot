(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:application-ast) environment continuation)
  (let* ((argument-asts (ico:argument-asts ast))
         (function-variable (gensym))
         (argument-variables
           (loop for argument-ast in argument-asts
                 collect (gensym "ARG")))
         (action `(progn (setf *continuation* ,continuation)
                         ,(push-stack-operation client)
                         (step (list ,@argument-variables)
                               ,function-variable))))
    (loop for argument-ast in (reverse argument-asts)
          for argument-variable in (reverse argument-variables)
          do (setf action
                   (cps client
                        argument-ast
                        environment
                        `(lambda (&rest ,argument-variable)
                           (setq ,argument-variable
                                 (car ,argument-variable))
                           ,action))))
    (cps client
         (ico:function-name-ast ast)
         environment
         `(lambda (&rest ,function-variable)
            (setf ,function-variable (car ,function-variable))
            ,action))))
