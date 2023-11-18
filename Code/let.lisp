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
    (let* ((new-environment environment)
           (declaration-asts (ico:declaration-asts ast))
           (special-declared-variable-asts
             (iat:extract-special-declared-variable-asts declaration-asts))
           (variable-name-asts
             (loop for binding-ast in (ico:binding-asts ast)
                   collect (ico:variable-name-ast binding-ast))))
      ;; FIXME: This call is a temporary simplification to allow us to
      ;; make progress.  It keeps only SPECIAL declarations.
      (trim-declaration-asts declaration-asts)
      (loop for special-declared-variable-ast
              in special-declared-variable-asts
            do (loop for variable-name-ast in variable-name-asts
                     do (when (eq (ico:name special-declared-variable-ast)
                                  (ico:name variable-name-ast))
                          (change-class variable-name-ast
                                        'ico:special-variable-bound-ast)
                          (return))))
      (loop for binding-ast in (ico:binding-asts ast)
            for variable-name-ast = (ico:variable-name-ast binding-ast)
            for form-ast = (ico:form-ast binding-ast)
            do (reinitialize-instance binding-ast
                 :form-ast (if (null form-ast)
                               nil
                               (convert-ast builder form-ast)))
               (setf new-environment
                     (finalize-parameter-variable
                      client variable-name-ast new-environment)))
      (loop for special-declared-variable-ast
              in special-declared-variable-asts
            for name = (ico:name special-declared-variable-ast)
            for description
              = (trucler:describe-variable client new-environment name)
            unless (typep description 'trucler:special-variable-description)
              do (setf new-environment
                       (trucler:add-local-special-variable
                        client new-environment name)))
      (finalize-declaration-asts client declaration-asts new-environment)
      (let ((new-builder (make-builder client new-environment)))
        (reinitialize-instance ast
          :form-asts (convert-asts new-builder (ico:form-asts ast)))))))
