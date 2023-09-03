(cl:in-package #:common-boot)

(defmethod abp:finish-node (builder kind (ast ico:function-ast))
  (let ((name-ast (ico:name-ast ast)))
    (with-builder-components (builder client environment)
      (if (typep name-ast 'ico:lambda-expression-ast)
          (let ((body-environment
                  (finalize-lambda-list
                   client environment (ico:lambda-list-ast name-ast))))
            (reinitialize-instance name-ast
              :form-asts
              (loop for form-ast in (ico:form-asts name-ast)
                    collect
                    (convert-ast-in-environment
                     client form-ast body-environment))))
          (finalize-function-name-ast-from-environment
           client (ico:name-ast ast) environment))))
  ast)
