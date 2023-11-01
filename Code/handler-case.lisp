(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:handler-case-ast))
  (with-builder-components (builder client environment)
    (loop for clause-ast in (ico:clause-asts ast)
          do (if (typep clause-ast 'ico:no-error-clause-ast)
                 (let* ((new-environment
                          (finalize-lambda-list
                           client environment
                           (ico:lambda-list-ast ast)
                           (ico:declaration-asts ast)))
                        (new-builder (make-builder client new-environment)))
                   (loop for form-ast in (ico:form-asts ast)
                         do (convert-ast new-builder form-ast)))
                 (let* ((variable-name-ast (ico:variable-name-ast clause-ast))
                        (new-environment
                          (if (null variable-name-ast)
                              environment
                              (finalize-parameter-variable
                               client variable-name-ast environment)))
                        (new-builder (make-builder client new-environment)))
                   (loop for form-ast in (ico:form-asts ast)
                         do (convert-ast new-builder form-ast)))))))
