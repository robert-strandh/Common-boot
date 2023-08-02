(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:multiple-value-bind-ast))
  (with-builder-components (builder client environment)
    (let ((new-environment environment))
      (loop for variable-name-ast in (ico:variable-name-asts ast)
            do (setf new-environment
                     (augment-environment-with-binding-variable
                      client
                      new-environment
                      variable-name-ast
                      (ico:declaration-asts ast))))
      (let ((new-builder (make-builder client new-environment)))
        (reinitialize-instance ast
          :values-ast (convert-ast builder (ico:values-ast ast))
          :form-asts
          (loop for form-ast in (ico:form-asts ast)
                do (convert-ast new-builder form-ast)))))))
