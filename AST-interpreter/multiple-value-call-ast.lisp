(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast
    (client environment (ast ico:multiple-value-call-ast))
  (apply (interpret-ast client environment (ico:function-ast ast))
         (loop for form-ast in (ico:form-asts ast)
               append (multiple-value-list
                       (interpret-ast client environment form-ast)))))
