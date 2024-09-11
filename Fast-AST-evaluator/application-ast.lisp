(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:application-ast))
  `(let ((*dynamic-environment* dynamic-environment)
         (function
           ,(translate-ast client environment (ico:function-name-ast ast)))
         (arguments
           (list ,@(loop for argument-ast in (ico:argument-asts ast)
                         collect (translate-ast
                                  client environment argument-ast)))))
     (let ((*stack* (cons (make-instance 'stack-entry
                            :origin ',(ico:origin ast)
                            :called-function function
                            :arguments arguments)
                          *stack*)))
       (apply function arguments))))
