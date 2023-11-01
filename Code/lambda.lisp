(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:lambda-ast))
  (with-builder-components (builder client environment)
    (let* ((new-environment
             (finalize-lambda-list
              client environment
              (ico:lambda-list-ast ast)
              (ico:declaration-asts ast)))
           (new-builder (make-builder client new-environment)))
      (loop for form-ast in (ico:form-asts ast)
            do (convert-ast new-builder form-ast)))))
