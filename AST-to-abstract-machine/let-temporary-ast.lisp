(cl:in-package #:common-boot-ast-to-abstract-machine)

(defmethod translate-ast (client context (ast ico:let-temporary-ast))
  (let* ((binding-ast (ico:binding-ast ast))
         (variable-definition-ast (ico:variable-name-ast binding-ast))
         (form-ast (ico:form-ast binding-ast))
         (register (new-register)))
    (assign-register variable-definition-ast register)
    (translate-ast client context form-ast)))
