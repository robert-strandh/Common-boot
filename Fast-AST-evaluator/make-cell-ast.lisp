(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:make-cell-ast))
  `(list ,(translate-ast client environment (ico:form-ast ast))))
