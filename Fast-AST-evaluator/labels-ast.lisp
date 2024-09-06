(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:local-function-ast))
  (setf (lookup (ico:name-ast ast)) (gensym))
  (let* ((lambda-list-ast (ico:lambda-list-ast ast))
         (lambda-list-variable-asts
           (iat:extract-variable-asts-in-lambda-list lambda-list-ast)))
    (loop for lambda-list-variable-ast in lambda-list-variable-asts
          do (setf (lookup lambda-list-variable-ast) (gensym)))
    (let ((host-lambda-list
            (host-lambda-list-from-lambda-list-ast lambda-list-ast)))
      `(,(lookup (ico:name-ast ast))
        ,host-lambda-list
        ,@(translate-implicit-progn
           client environment (ico:form-asts ast))))))

(defmethod translate-ast (client environment (ast ico:labels-ast))
  `(labels ,(loop for function-ast in (ico:binding-asts ast)
                  collect (translate-ast client environment function-ast))
     ,@(translate-implicit-progn client environment (ico:form-asts ast))))
