(cl:in-package #:common-boot)

;;; FIXME: handle declarations
(defmethod finalize-local-function-ast
    (client (ast ico:local-function-ast) environment)
  ;; FIXME: This call is a temporary simplification to allow us to
  ;; make progress.  It keeps only SPECIAL declarations.
  (trim-declaration-asts (ico:declaration-asts ast))
  (change-class (ico:name-ast ast)
                'ico:function-definition-ast)
  (let ((body-environment
          (finalize-lambda-list
           client environment
           (ico:lambda-list-ast ast)
           (ico:declaration-asts ast))))
    (let* ((name (ico:name (ico:name-ast ast)))
           (block-name-ast
             (make-instance 'ico:block-name-definition-ast
               :name name
               :origin (ico:origin ast)))
           (forms-environment
             (trucler:add-block
              client body-environment name block-name-ast)))
      (reinitialize-instance ast
        :form-asts
        (list (make-instance 'ico:block-ast
                :name-ast block-name-ast
                :form-asts
                (loop for form-ast in (ico:form-asts ast)
                      collect
                      (convert-ast-in-environment
                       client form-ast forms-environment))))))))

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:flet-ast))
  (with-builder-components (builder client environment)
    (let ((new-environment environment))
      (loop for local-function-ast in (ico:binding-asts ast)
            for name-ast = (ico:name-ast local-function-ast)
            do (finalize-local-function-ast
                client local-function-ast environment)
               (setf new-environment
                     (augment-environment-with-local-function-name
                      client name-ast new-environment)))
      (reinitialize-instance ast
        :form-asts
        (loop for form-ast in (ico:form-asts ast)
              collect
              (convert-ast-in-environment
               client form-ast new-environment)))))
  ast)
