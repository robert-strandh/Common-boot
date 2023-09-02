(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:application-ast) continuation)
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
                  (if (typep ,function-variable 'cps-function)
                      (step (list ,@argument-variables)
                            ,function-variable)
                      (progn (setf *arguments*
                                   (multiple-value-list
                                    (funcall ,function-variable
                                             ,@argument-variables)))
                             (pop-stack)))))
              ,@(loop for argument-ast in (reverse argument-asts)
                      for argument-variable in (reverse argument-variables)
                      collect `(,name (lambda (&rest var)
                                        (setq ,argument-variable (car var))
                                        (step nil ,name)))
                      collect `(,name (lambda (&rest ignore)
                                        (declare (ignore ignore))
                                        ,(cps client
                                              argument-ast
                                              name))))
              (,name (lambda (&rest var)
                       (setf ,function-variable (car var))
                       (step nil ,name))))
         (setq *dynamic-environment* dynamic-environment)
         (setq *continuation* ,continuation)
         (push-stack)
         ,(cps client
               (ico:function-name-ast ast)
               name)))))
