(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast
    (client environment (ast ico:let-temporary-ast))
  (let* ((binding-ast (ico:binding-ast ast))
         (variable-definition-ast (ico:variable-name-ast binding-ast))
         (form-ast (ico:form-ast binding-ast))
         (form-asts (ico:form-asts ast))
         (new-environment environment))
    (push (cons variable-definition-ast
                (interpret-ast client environment form-ast))
          new-environment)
    (interpret-implicit-progn-asts client new-environment form-asts)))
