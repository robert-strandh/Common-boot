(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:with-output-to-string-ast))
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
          :form-asts (convert-asts new-builder (ico:form-asts ast)))))))
