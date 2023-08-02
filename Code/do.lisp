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
            for init-form-ast = (ico:init-form-ast ast)
            for step-form-ast = (ico:step-form-ast ast)
            do (reinitialize-instance variable-ast
                 :init-form-ast (if (null init-form-ast)
                                    nil
                                    (convert-ast builder init-form-ast))
                 :step-form-ast (if (null step-form-ast)
                                    nil
                                    (convert-ast builder step-form-ast)))
               (setf new-environment
                     (augment-environment-with-binding-variable
                      client
                      new-environment
                      variable-name-ast
                      (ico:declaration-asts ast))))
      (let ((new-builder (make-builder client new-environment)))
        (reinitialize-instance ast
          :end-test-ast (convert-ast new-builder (ico:end-test-ast ast))
          :result-asts
          (loop for result-ast in (ico:result-asts ast)
                collect (convert-ast new-builder result-ast)))
        (loop for ast in (ico:segment-asts ast)
              do (reinitialize-instance ast
                   :statement-asts
                   (loop for statement-ast in (ico:statement-asts ast)
                         collect (convert-ast new-builder ast))))))))
