(cl:in-package #:common-boot-ast-to-abstract-machine)

(defmethod translate-ast (client context (ast ico:let-temporary-ast))
  (let* ((binding-ast (ico:binding-ast ast))
         (variable-definition-ast (ico:variable-name-ast binding-ast))
         (form-ast (ico:form-ast binding-ast))
         (form-asts (ico:form-asts ast)))
    (with-new-register (variable-definition-ast register)
      (let* ((body-code
              (translate-implicit-progn client context form-asts))
             (new-context
               (make-context (next-instructions body-code) 1 register)))
        (translate-ast client new-context form-ast)))))

