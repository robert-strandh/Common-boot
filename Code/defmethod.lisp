(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:defmethod-ast))
  (change-class (ico:name-ast ast) 'ico:global-function-name-reference-ast)
  (with-builder-components (builder client environment)
    (let ((body-environment
            (finalize-lambda-list
             client environment (ico:lambda-list-ast ast))))
      (reinitialize-instance ast
        :form-asts
        (loop with new-builder = (make-builder client body-environment)
              for form-ast in (ico:form-asts ast)
              collect (convert-ast new-builder form-ast))))))
