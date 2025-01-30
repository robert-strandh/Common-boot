(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:function-ast))
  (translate-ast client (ico:name-ast ast)))
