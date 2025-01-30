(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:quote-ast))
  `',(cst:raw (ico:form (ico:object-ast ast))))
