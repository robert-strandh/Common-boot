(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:block-ast))
  (let* ((name-ast (ico:name-ast ast))
         (host-name (gensym)))
    (setf (lookup name-ast) host-name)
    `(block ,host-name
       ,@(translate-implicit-progn client environment (ico:form-asts ast)))))
