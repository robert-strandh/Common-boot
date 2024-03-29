(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:let*-ast))
  ;; FIXME: This call is a temporary simplification to allow us to
  ;; make progress.  It keeps only SPECIAL declarations.
  (trim-declaration-asts (ico:declaration-asts ast))
  (let ((new-builder builder))
    (loop for binding-ast in (ico:binding-asts ast)
          for variable-name-ast = (ico:variable-name-ast binding-ast)
          for form-ast = (ico:form-ast binding-ast)
          do (reinitialize-instance binding-ast
               :form-ast (if (null form-ast)
                             nil
                             (convert-ast new-builder form-ast)))
             (with-builder-components (new-builder client environment)
               (setf new-builder
                     (make-builder
                      client
                      (augment-environment-with-binding-variable
                       client
                       environment
                       variable-name-ast
                       (ico:declaration-asts ast))))))
    (reinitialize-instance ast
      :form-asts (convert-asts new-builder (ico:form-asts ast)))))
