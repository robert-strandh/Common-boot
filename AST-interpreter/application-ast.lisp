(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:application-ast))
  (apply (interpret-ast client environment (ico:function-name-ast ast))
         (loop for argument-ast in (ico:argument-asts ast)
               collect (interpret-ast client environment argument-ast))))
