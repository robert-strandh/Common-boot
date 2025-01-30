(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:make-cell-ast))
  `(list ,(translate-ast client (ico:form-ast ast))))
