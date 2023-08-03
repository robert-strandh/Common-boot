(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:dotimes-ast))
  (with-builder-components (builder client environment)
    (let ((new-environment
            (augment-environment-with-binding-variable
             client
             environment
             (ico:variable-name-ast ast)
             (ico:declaration-asts ast))))
      (let ((new-builder (make-builder client new-environment)))
        (reinitialize-instance ast
          :count-form-ast (convert-ast builder (ico:count-form-ast ast))
          :result-ast
          (convert-optional-ast new-builder (ico:result-ast ast)))
        (loop for ast in (ico:segment-asts ast)
              do (reinitialize-instance ast
                   :statement-asts
                   (convert-asts new-builder (ico:statement-asts ast))))))))
