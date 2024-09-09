(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:literal-ast))
  `',(ico:literal ast))
