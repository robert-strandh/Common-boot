(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast
    (client (ast ico:special-variable-bind-ast))
  (let* ((binding-ast (ico:binding-ast ast))
         (variable-name-ast (ico:variable-name-ast binding-ast))
         (name (ico:name variable-name-ast))
         (form-ast (ico:form-ast binding-ast))
         (form-asts (ico:form-asts ast)))
    `(let ((dynamic-environment dynamic-environment))
       (declare (ignorable dynamic-environment))
       (push (make-instance 'special-variable-entry
               :name ',name
               :value ,(translate-ast client form-ast))
             dynamic-environment)
       ,@(translate-implicit-progn client form-asts))))
