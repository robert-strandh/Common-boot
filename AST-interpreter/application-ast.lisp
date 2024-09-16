(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:application-ast))
  (apply (interpret-ast client environment (ico:function-name-ast ast))
         (interpret-implicit-progn-asts
          client environment (ico:argument-asts ast))))
