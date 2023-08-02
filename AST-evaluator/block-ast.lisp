(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:block-ast) environment continuation)
  (let ((name (gensym)))
    (setf (lookup ast environment) name)
    `(progn (push (make-instance 'block-entry
                    :name ',name
                    :continuation ,continuation)
                  *dynamic-environment*)
            ,(cps-implicit-progn
              client (ico:form-asts ast) environment continuation))))
