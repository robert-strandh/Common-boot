(cl:in-package #:common-boot)

(defmethod convert-ast (builder (ast ico:unparsed-form-ast))
  (with-builder-components (builder client environment)
    (convert client (ico:form ast) environment)))

(defmethod convert-ast-in-environment
    (client (ast ico:unparsed-form-ast) environment)
  (convert client (ico:form ast) environment))
