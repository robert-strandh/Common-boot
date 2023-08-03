(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:prog*-ast))
  (let ((new-builder builder))
    (loop for binding-ast in (ico:binding-asts ast)
          for variable-name-ast = (ico:variable-name-ast binding-ast)
          do (reinitialize-instance binding-ast
               :form-ast
               (convert-optional-ast new-builder (ico:form-ast ast)))
             (with-builder-components (new-builder client environment)
               (setf new-builder
                     (make-builder
                      client
                      (augment-environment-with-binding-variable
                       client
                       environment
                       variable-name-ast
                       (ico:declaration-asts ast))))))
    (loop for ast in (ico:segment-asts ast)
          do (reinitialize-instance ast
               :statement-asts
               (loop for statement-ast in (ico:statement-asts ast)
                     collect (convert-ast new-builder ast))))))
