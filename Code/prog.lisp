(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:prog-ast))
    (with-builder-components (builder client environment)
      (let ((new-environment environment))
        (loop for binding-ast in (ico:binding-asts ast)
              for variable-name-ast = (ico:variable-name-ast binding-ast)
              do (reinitialize-instance binding-ast
                   :form-ast
                   (convert-optional-ast builder (ico:form-ast ast)))
                 (setf new-environment
                       (augment-environment-with-binding-variable
                        client
                        new-environment
                        variable-name-ast
                        (ico:declaration-asts ast))))
        (let ((new-builder (make-builder client new-environment)))
          (loop for ast in (ico:segment-asts ast)
                do (reinitialize-instance ast
                     :statement-asts
                     (convert-asts new-builder (ico:statement-asts ast))))))))
