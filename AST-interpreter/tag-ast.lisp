(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environement (ast ico:tag-ast))
  (cst:raw (ico:name ast)))
