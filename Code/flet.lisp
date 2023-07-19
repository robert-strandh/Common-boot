(cl:in-package #:common-boot)

;;; FIXME: handle declarations
(defmethod finalize-local-function-ast
    (client (ast ico:local-function-ast) environment)
  (let ((body-environment
          (finalize-ordinary-lambda-list
           client environment (ico:lambda-list-ast ast))))
    (reinitialize-instance ast
      :form-asts
      (loop for form-ast in (ico:form-asts ast)
            collect
            (convert-ast-in-environment client form-ast body-environment)))
    (augment-environment-with-local-function-name
     client (ico:name-ast ast) environment)))

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:flet-ast))
  (with-builder-components (builder client environment)
    (let ((new-environment environment))
      (loop for local-function-ast in (ico:binding-asts ast)
            do (setf new-environment
                     (finalize-local-function-ast
                      client local-function-ast new-environment)))
      (reinitialize-instance ast
        :form-asts
        (loop for form-ast in (ico:form-asts ast)
              collect
              (convert-ast-in-environment client form-ast new-environment)))
      new-environment)))
