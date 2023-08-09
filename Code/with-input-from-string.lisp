(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:with-input-from-string-ast))
  (with-builder-components (builder client environment)
    (let* ((variable-name-ast (ico:var-ast ast))
           (new-environment
             (augment-environment-with-binding-variable
              client
              environment
              variable-name-ast
              (ico:declaration-asts ast))))
      (let ((new-builder (make-builder client new-environment)))
        (reinitialize-instance ast
          :string-ast (convert-ast new-builder (ico:string-ast ast))
          :index-ast (convert-optional-ast new-builder (ico:index-ast ast))
          :start-ast (convert-optional-ast new-builder (ico:start-ast ast))
          :end-ast (convert-optional-ast new-builder (ico:end-ast ast))
          :form-asts (convert-asts new-builder (ico:form-asts ast)))))))
