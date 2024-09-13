(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:let-temporary-ast))
  (let* ((binding-ast (ico:binding-ast ast))
         (variable-name-ast (ico:variable-name-ast binding-ast))
         (form-ast (ico:form-ast binding-ast))
         (host-variable (gensym)))
    (setf (lookup variable-name-ast) host-variable)
    `(let ((,host-variable ,(translate-ast client environment form-ast)))
       ,@(translate-implicit-progn client environment (ico:form-asts ast)))))
