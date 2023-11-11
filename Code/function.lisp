(cl:in-package #:common-boot)

(defmethod abp:finish-node (builder kind (ast ico:function-ast))
  (let ((name-ast (ico:name-ast ast)))
    (with-builder-components (builder client environment)
      (if (typep name-ast 'ico:lambda-expression-ast)
          (let ((labels-ast (iat:function-lambda-to-labels ast)))
            (finish-labels-ast builder labels-ast))
          (progn (finalize-function-name-ast-from-environment
                  client (ico:name-ast ast) environment)
                 ast)))))
