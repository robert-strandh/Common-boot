(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:function-ast))
  (translate-ast client environment (ico:name-ast ast)))
