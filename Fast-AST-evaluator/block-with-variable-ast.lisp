(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast
    (client (ast ico:block-with-variable-ast))
  (let* ((catch-tag-variable (gensym))
         (host-variable (gensym)))
    (setf (lookup (ico:variable-definition-ast ast)) host-variable)
    `(let ((dynamic-environment dynamic-environment)
           (,catch-tag-variable (list nil))
           (,host-variable (list nil)))
       (declare (ignorable dynamic-environment))
       (push (make-instance 'block-entry
               :name ,host-variable
               :unwinder (lambda (values)
                           (throw ,catch-tag-variable
                             (apply #'values values))))
             dynamic-environment)
       (catch ,catch-tag-variable
         ,@(translate-implicit-progn
            client (ico:form-asts ast))))))
