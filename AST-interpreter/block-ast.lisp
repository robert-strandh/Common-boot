(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:block-ast))
  (let ((*dynamic-environment* *dynamic-environment*)
        (catch-tag (gensym)))
    (push (make-instance 'block-entry
            :name (ico:name-ast ast)
            :unwinder (lambda (values)
                        (throw catch-tag (apply #'values values))))
          *dynamic-environment*)
    (catch catch-tag
      (interpret-implicit-progn-asts
       client environment (ico:form-asts ast)))))
