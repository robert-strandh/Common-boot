(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:locally-ast))
  (translate-implicit-progn client (ico:form-asts ast)))
