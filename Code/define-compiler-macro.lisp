(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:define-compiler-macro-ast))
  (change-class (ico:name-ast ast)
                'ico:global-function-name-reference-ast)
  (with-builder-components (builder client environment)
    (let* ((body-environment
             (finalize-lambda-list
              client environment
              (ico:lambda-list-ast ast)
              (ico:declaration-asts ast)))
           (new-builder (make-builder client body-environment)))
      (reinitialize-instance ast
        :form-asts (convert-asts new-builder (ico:form-asts ast))))))
