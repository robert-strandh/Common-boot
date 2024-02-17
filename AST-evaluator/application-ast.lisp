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
                (make-before-continuation
                 (lambda (&rest ignore)
                   (declare (ignore ignore))
                   (setq *continuation* ,continuation)
                   (step (multiple-value-list
                          (apply-with-origin
                           ,function-variable
                           (list ,@argument-variables)
                           ',(ico:origin ast)))
                         ,continuation))
                 :origin ',(ico:origin ast)
                 :next ,continuation))
              ,@(loop for argument-ast in (reverse argument-asts)
                      for argument-variable in (reverse argument-variables)
                      when (typep argument-ast 'ico:variable-reference-ast)
                        collect
                        (let* ((definition-ast
                                 (ico:variable-definition-ast argument-ast))
                               (host-variable (lookup definition-ast)))
                          `(,name (make-before-continuation 
                                   (lambda (&rest ignore)
                                     (declare (ignore ignore))
                                     (setq ,argument-variable
                                           (car ,host-variable))
                                     (step nil ,name))
                                   :origin ',(ico:origin argument-ast)
                                   :next ,name)))
                      unless (typep argument-ast 'ico:variable-reference-ast)
                        collect `(,name (make-before-continuation
                                         (lambda (&rest var)
                                           (setq ,argument-variable (car var))
                                           (step nil ,name))
                                         :origin ',(ico:origin argument-ast)
                                         :next ,name))
                      unless (typep argument-ast 'ico:variable-reference-ast)
                        collect `(,name (make-before-continuation
                                         (lambda (&rest ignore)
                                           (declare (ignore ignore))
                                           ,(cps client environment
                                                 argument-ast
                                                 name))
                                         :origin ',(ico:origin argument-ast)
                                         :next ,name)))
              (,name (make-before-continuation
                      (lambda (&rest var)
                        (setf ,function-variable (car var))
                        (step nil ,name))
                      :origin ',(ico:origin (ico:function-name-ast ast))
                      :next ,name)))
         (setq *dynamic-environment* dynamic-environment)
         ,(cps client environment
               (ico:function-name-ast ast)
               name)))))
