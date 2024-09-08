(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:catch-ast))
  (let ((block-name (gensym)))
    `(let ((dynamic-environment dynamic-environment))
       (block ,block-name
         (push (make-instance 'catch-entry
                 :name ,(translate client environment (ico:tag-ast ast))
                 :unwinder (lambda (values)
                             (return-from ,block-name
                               (apply #'values values))))
               dynamic-environment)
         ,(translate-implicit-progn
           client environment (ico:form-asts ast))))))
