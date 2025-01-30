(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:tag-ast))
  (cst:raw (ico:name ast)))
