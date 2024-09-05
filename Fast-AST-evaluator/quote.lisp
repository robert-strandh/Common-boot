(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:quote-ast))
  `',(cst:raw (ico:form (ico:object-ast ast))))
