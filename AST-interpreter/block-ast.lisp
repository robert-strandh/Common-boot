(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:block-ast))
  (let* ((*dynamic-environment* *dynamic-environment*)
         (catch-tag (gensym))
         (identity (list nil))
         (new-environment (acons (ico:name-ast ast) identity environment)))
    (push (make-instance 'block-entry
            :name identity
            :unwinder (lambda (values)
                        (throw catch-tag (apply #'values values))))
          *dynamic-environment*)
    (catch catch-tag
      (interpret-implicit-progn-asts
       client new-environment (ico:form-asts ast)))))
