(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:application-ast))
  (let ((function-name-ast (ico:function-name-ast ast))
        (argument-forms (loop for argument-ast in (ico:argument-asts ast)
                              collect (translate-ast
                                       client environment argument-ast))))
    (if (typep function-name-ast 'ico:global-function-name-reference-ast)
        `(let ((*dynamic-environment* dynamic-environment)
               (function
                 ,(translate-ast client environment function-name-ast))
               (arguments (list ,@argument-forms)))
           (let ((cb:*stack* (cons (make-instance 'cb:stack-entry
                                     :origin ',(ico:origin ast)
                                     :called-function function
                                     :arguments arguments)
                                   cb:*stack*)))
             (apply function arguments)))
        `(let ((*dynamic-environment* dynamic-environment)
               (function
                 ,(translate-ast client environment function-name-ast)))
           (funcall function ,@argument-forms)))))
