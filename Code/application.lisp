(cl:in-package #:common-boot)

(defmethod abp:finish-node (builder kind (ast ico:application-ast))
  (let ((operator-ast (ico:function-name-ast ast)))
    (if (typep operator-ast 'ico:lambda-expression-ast)
        (reinitialize-instance operator-ast
          :form-asts
          (loop for body-ast in (ico:form-asts operator-ast)
                collect (convert-ast builder body-ast)))
        (with-builder-components (builder client environment)
          (finalize-function-name-ast-from-environment
           client operator-ast environment))))
  ;; We assume that each argument is an unparsed form.
  (reinitialize-instance ast
    :argument-asts
    (loop for argument-ast in (ico:argument-asts ast)
          collect (convert-ast builder argument-ast))))
