(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:function-ast))
  (interpret-ast client environment (ico:name-ast ast)))
