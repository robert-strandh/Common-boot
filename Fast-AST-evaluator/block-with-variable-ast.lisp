(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast
    (client (ast ico:block-with-variable-ast))
  (let* ((catch-tag (gensym))
         (identity (list nil)))
    `(let ((dynamic-environment dynamic-environment))
       (declare (ignorable dynamic-environment))
       (push (make-instance 'block-entry
               :name ',identity
               :unwinder (lambda (values)
                           (throw ',catch-tag (apply #'values values))))
             dynamic-environment)
       (catch ',catch-tag
         ,@(translate-implicit-progn
            client (ico:form-asts ast))))))
