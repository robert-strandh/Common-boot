(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:application-ast) environment continuation)
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
                  (step (list ,@argument-variables) ,function-variable)))
              ,@(loop for argument-ast in (reverse argument-asts)
                      for argument-variable in (reverse argument-variables)
                      collect `(,name (lambda (&rest var)
                                        (setq ,argument-variable (car var))
                                        (step nil ,name)))
                      collect `(,name (lambda (&rest ignore)
                                        (declare (ignore ignore))
                                        ,(cps client
                                              argument-ast
                                              environment
                                              name))))
              (,name (lambda (&rest var)
                       (setf ,function-variable (car var))
                       (step nil ,name))))
         (setq *continuation* ,continuation)
         (push-stack)
         ,(cps client
               (ico:function-name-ast ast)
               environment
               name)))))
