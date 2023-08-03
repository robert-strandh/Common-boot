(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:do*-ast))
  (let ((new-builder builder))
    (loop with variable-asts = (ico:do-iteration-variable-asts ast)
          for variable-ast in variable-asts
          for variable-name-ast = (ico:variable-name-ast variable-ast)
          for init-form-ast = (ico:init-form-ast ast)
          for step-form-ast = (ico:step-form-ast ast)
          do (reinitialize-instance variable-ast
               :init-form-ast
               (convert-optional-ast new-builder (ico:init-form-ast ast))
               :step-form-ast
               (convert-optional-ast new-builder (ico:step-form-ast ast)))
             (with-builder-components (new-builder client environment)
               (setf new-builder
                     (make-builder
                      client
                      (augment-environment-with-binding-variable
                       client
                       environment
                       variable-name-ast
                       (ico:declaration-asts ast))))))
    (reinitialize-instance ast
      :end-test-ast (convert-ast new-builder (ico:end-test-ast ast))
      :result-asts (convert-asts new-builder (ico:result-asts ast)))
    (loop for ast in (ico:segment-asts ast)
          do (reinitialize-instance ast
               :statement-asts
               (convert-asts new-builder (ico:statement-asts ast))))))
    
