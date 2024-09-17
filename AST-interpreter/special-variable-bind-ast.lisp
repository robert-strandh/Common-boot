(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast
    (client environment (ast ico:special-variable-bind-ast))
  (let* ((binding-ast (ico:binding-ast ast))
         (variable-name-ast (ico:variable-name-ast binding-ast))
         (name (ico:name variable-name-ast))
         (form-ast (ico:form-ast binding-ast))
         (form-asts (ico:form-asts ast)))
    (let ((*dynamic-environment* *dynamic-environment*))
      (push (make-instance 'special-variable-entry
              :name name
              :value (interpret-ast client environment form-ast))
            *dynamic-environment*)
      (interpret-implicit-progn-asts client environment form-asts))))
