(cl:in-package #:common-boot)

(defun finish-labels-ast (builder labels-ast)
  (with-builder-components (builder client environment)
    (let ((new-environment environment))
      (loop for local-function-ast in (ico:binding-asts labels-ast)
            for name-ast = (ico:name-ast local-function-ast)
            do (change-class name-ast 'ico:function-definition-ast)
               (setf new-environment
                     (augment-environment-with-local-function-name
                      client name-ast new-environment)))
      (loop for local-function-ast in (ico:binding-asts labels-ast)
            do (finalize-local-function-ast
                client local-function-ast new-environment))
      (reinitialize-instance labels-ast
        :form-asts
        (loop for form-ast in (ico:form-asts labels-ast)
              collect
              (convert-ast-in-environment
               client form-ast new-environment))))))

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:labels-ast))
  (finish-labels-ast builder ast)
  ast)
