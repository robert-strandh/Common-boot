(cl:in-package #:common-boot)

;;; FIXME: this function is very similar to
;;; AUGMENT-ENVIRONMENT-WITH-VARIABLE.
(defun augment-environment-with-binding-variable
    (client environment variable-name-ast declaration-asts)
  (let ((variable-name (ico:name variable-name-ast)))
    (multiple-value-bind (special-p globally-special-p)
        (variable-is-special-p
         client
         variable-name-ast
         declaration-asts
         environment)
      (change-class variable-name-ast
                    (if special-p
                        'ico:special-variable-bound-ast
                        'ico:variable-definition-ast))
      (if special-p
          (unless globally-special-p
            (trucler:add-local-special-variable
             client environment variable-name))
          (trucler:add-lexical-variable
           client environment
           variable-name variable-name-ast)))))

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:let-ast))
  (with-builder-components (builder client environment)
    (let ((new-environment environment))
      (loop for binding-ast in (ico:binding-asts ast)
            for variable-name-ast = (ico:variable-name-ast binding-ast)
            for form-ast = (ico:form-ast binding-ast)
            do (reinitialize-instance binding-ast
                 :form-ast (if (null form-ast)
                               nil
                               (convert-ast builder form-ast)))
               (setf new-environment
                     (augment-environment-with-binding-variable
                      client
                      new-environment
                      variable-name-ast
                      (ico:declaration-asts ast))))
      (finalize-declaration-asts
       client (ico:declaration-asts ast) new-environment)
      (let ((new-builder (make-builder client new-environment)))
        (reinitialize-instance ast
          :form-asts (convert-asts new-builder (ico:form-asts ast)))))))
