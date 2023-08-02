(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:dolist-ast))
  (with-builder-components (builder client environment)
    (let ((new-environment
            (augment-environment-with-binding-variable
             client
             environment
             (ico:variable-name-ast ast)
             (ico:declaration-asts ast))))
      (let ((new-builder (make-builder client new-environment)))
        (reinitialize-instance ast
          :list-form-ast (convert-ast builder (ico:list-form-ast ast))
          :result-ast (if (null (ico:result-ast ast))
                          nil
                          (convert-ast new-builder (ico:result-ast ast))))
        (loop for ast in (ico:segment-asts ast)
              do (reinitialize-instance ast
                   :statement-asts
                   (loop for statement-ast in (ico:statement-asts ast)
                         collect (convert-ast new-builder ast))))))))
