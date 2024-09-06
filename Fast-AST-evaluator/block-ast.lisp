(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:block-ast))
  (let* ((name-ast (ico:name-ast ast))
         (host-name (gensym)))
    (setf (lookup name-ast) host-name)
    `(let ((dynamic-environment dynamic-environment))
       (declare (ignorable dynamic-environment))
       (block ,host-name
         (push (make-instance 'block-entry
                 :name ,name-ast
                 :unwinder
                 (lambda (values)
                   (return-from ,host-name
                     (apply #'values values))))
               dynamic-environment)
         ,@(translate-implicit-progn
            client environment (ico:form-asts ast))))))
