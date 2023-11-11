(cl:in-package #:common-boot)

(defmethod abp:finish-node (builder kind (ast ico:application-ast))
  (let ((operator-ast (ico:function-name-ast ast)))
    (with-builder-components (builder client environment)
      (if (typep operator-ast 'ico:lambda-expression-ast)
          (let ((labels-ast (iat:application-lambda-to-labels ast)))
            (finish-labels-ast builder labels-ast))
          (finalize-function-name-ast-from-environment
           client operator-ast environment))))
  ;; We assume that each argument is an unparsed form.
  (reinitialize-instance ast
    :argument-asts
    (loop for argument-ast in (ico:argument-asts ast)
          collect (convert-ast builder argument-ast))))
