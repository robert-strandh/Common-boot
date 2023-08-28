(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:labels-ast))
  (with-builder-components (builder client environment)
    (let ((new-environment environment))
      (loop for local-function-ast in (ico:binding-asts ast)
            for name-ast = (ico:name-ast local-function-ast)
            do (setf new-environment
                     (augment-environment-with-local-function-name
                      client name-ast new-environment)))
      (loop for local-function-ast in (ico:binding-asts ast)
            do (finalize-local-function-ast
                client local-function-ast new-environment))
      (reinitialize-instance ast
        :form-asts
        (loop for form-ast in (ico:form-asts ast)
              collect
              (convert-ast-in-environment
               client form-ast new-environment)))))
  ast)
