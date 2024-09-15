(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:quote-ast))
  (cst:raw (ico:form (ico:object-ast ast))))
