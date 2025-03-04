(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:eval-when-ast))
  (translate-implicit-progn client (ico:form-asts ast)))
