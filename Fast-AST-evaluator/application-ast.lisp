(cl:in-package #:common-boot-fast-ast-evaluator)

(defmacro with-stack-entry ((origin function arguments) &body body)
  `(let ((cb:*stack* (cons (make-instance 'cb:stack-entry
                             :origin ',origin
                             :called-function ,function
                             :arguments ,arguments)
                           cb:*stack*)))
     ,@body))

(defmethod translate-ast (client (ast ico:application-ast))
  (let ((function-name-ast (ico:function-name-ast ast))
        (argument-forms (loop for argument-ast in (ico:argument-asts ast)
                              collect (translate-ast
                                       client argument-ast))))
    (if (typep function-name-ast 'ico:global-function-name-reference-ast)
        `(let ((*dynamic-environment* dynamic-environment)
               (function
                 ,(translate-ast client function-name-ast))
               (arguments (list ,@argument-forms)))
           (with-stack-entry (,(ico:origin ast) function arguments)
             (if (typep function 'closure)
                 (let ((*static-environment* (static-environment function)))
                   (declare (special *static-environment*))
                   (apply function arguments))
                 (apply function arguments))))
        `(let ((*dynamic-environment* dynamic-environment)
               (function
                 ,(translate-ast client function-name-ast)))
           (if (typep function 'closure)
               (let ((*static-environment* (static-environment function)))
                 (declare (special *static-environment*))
                 (funcall function ,@argument-forms))
               (funcall function ,@argument-forms))))))
