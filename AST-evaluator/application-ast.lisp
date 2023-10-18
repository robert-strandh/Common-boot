(cl:in-package #:common-boot-ast-evaluator)

(defun cps-application-optimized (client ast continuation)
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
              (,name (lambda (&rest var)
                       (setf ,function-variable (car var))
                       ,@(loop for argument-ast in argument-asts
                               for argument-variable in argument-variables
                               collect
                               (etypecase argument-ast
                                 (ico:literal-ast
                                  `(setq ,argument-variable
                                         ,(ico:literal argument-ast)))
                                 (ico:variable-reference-ast
                                  (let* ((definition-ast
                                           (ico:variable-definition-ast
                                            argument-ast))
                                         (host-variable (lookup definition-ast)))
                                    `(setq ,argument-variable
                                           (car ,host-variable))))))
                       (step nil ,name))))
         (setq *dynamic-environment* dynamic-environment)
         (setq *continuation* ,continuation)
         (push-stack)
         ,(cps client
               (ico:function-name-ast ast)
               name)))))
  
(defun cps-application-general (client ast continuation)
  (let* ((argument-asts (ico:argument-asts ast))
         (function-variable (gensym "FUN-"))
         (argument-variables
           (loop for argument-ast in argument-asts
                 collect (gensym "ARG-")))
         (name (gensym "C-")))
    (print (ico:function-name-ast ast))
    `(let ,(cons function-variable argument-variables)
       (let* ((,name
                (lambda (&rest ignore)
                  (declare (ignore ignore))
                  (call-function ,function-variable (list ,@argument-variables))))
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

(defmethod cps (client (ast ico:application-ast) continuation)
  (if (every (lambda (ast)
               (typep ast '(or ico:literal-ast ico:variable-reference-ast )))
             (ico:argument-asts ast))
      (cps-application-optimized client ast continuation)
      (cps-application-general client ast continuation)))
