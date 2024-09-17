(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:catch-ast))
  (let ((*dynamic-environment* *dynamic-environment*))
    (push (make-instance 'catch-entry
            :name (ico:tag-ast ast)
            :unwinder (lambda (values)
                        (throw (ico:tag-ast ast)
                          (apply #'values values))))
          *dynamic-environment*)
    (catch (ico:tag-ast ast)
      (interpret-implicit-progn-asts
       client environment (ico:form-asts ast)))))
