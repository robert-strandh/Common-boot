(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:do-ast))
  (with-builder-components (builder client environment)
    (let ((new-environment environment))
      (loop with variable-asts = (ico:do-iteration-variable-asts ast)
            for variable-ast in variable-asts
            for variable-name-ast = (ico:do-variable-name-ast variable-ast)
            do (reinitialize-instance variable-ast
                 :init-form-ast
                 (convert-optional-ast builder (ico:init-form-ast ast))
                 :step-form-ast
                 (convert-optional-ast builder (ico:step-form-ast ast)))
               (setf new-environment
                     (augment-environment-with-binding-variable
                      client
                      new-environment
                      variable-name-ast
                      (ico:declaration-asts ast))))
      (let ((new-builder (make-builder client new-environment)))
        (reinitialize-instance ast
          :end-test-ast (convert-ast new-builder (ico:end-test-ast ast))
          :result-asts (convert-asts new-builder (ico:result-asts ast)))
        (loop for ast in (ico:segment-asts ast)
              do (reinitialize-instance ast
                   :statement-asts
                   (convert-asts new-builder (ico:statement-asts ast))))))))
