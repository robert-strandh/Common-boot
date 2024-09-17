(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:catch-ast))
  (let* ((*dynamic-environment* *dynamic-environment*)
         (tag-ast (ico:tag-ast ast))
         (tag (interpret-ast client environment tag-ast)))
    (push (make-instance 'catch-entry
            :name tag
            :unwinder (lambda (values)
                        (throw tag
                          (apply #'values values))))
          *dynamic-environment*)
    (catch tag
      (interpret-implicit-progn-asts
       client environment (ico:form-asts ast)))))
