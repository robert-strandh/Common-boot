(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:application-ast))
  `(let ((*dynamic-environment* dynamic-environment))
     (funcall
      ,(translate-ast client environment (ico:function-name-ast ast))
      ,@(loop for argument-ast in (ico:argument-asts ast)
              collect (translate-ast client environment argument-ast)))))
