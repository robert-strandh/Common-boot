(cl:in-package #:common-boot)

(defmethod finalize-local-macro-ast
    (client (ast ico:local-function-ast) environment)
  ;; FIXME: This call is a temporary simplification to allow us to
  ;; make progress.  It keeps only SPECIAL declarations.
  (trim-declaration-asts (ico:declaration-asts ast))
  (change-class (ico:name-ast ast)
                'ico:local-function-name-definition-ast)
  (let ((body-environment
          (finalize-lambda-list
           client environment
           (ico:lambda-list-ast ast)
           (ico:declaration-asts ast))))
    (reinitialize-instance ast
      :form-asts
      (loop for form-ast in (ico:form-asts ast)
            collect
            (convert-ast-in-environment client form-ast body-environment)))))


(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:macrolet-ast))
  (with-builder-components (builder client environment)
    (let ((new-environment environment))
      (loop for local-macro-ast in (ico:binding-asts ast)
            for name-ast = (ico:name-ast local-macro-ast)
            do (finalize-local-macro-ast
                client local-macro-ast environment)
               (setf new-environment
                     (augment-environment-with-local-macro-name
                      client name-ast environment)))
      (reinitialize-instance ast
        :form-asts
        (loop for form-ast in (ico:form-asts ast)
              collect
              (convert-ast-in-environment
               client form-ast new-environment)))))
  ast)
