(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:literal-ast))
  `',(ico:literal ast))
