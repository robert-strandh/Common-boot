(cl:in-package #:common-boot)

;;; BUILDER is a builder to use for converting the value forms in the
;;; binding, ENVIRONMENT is the environment to augment with the
;;; variable of the binding.  The augmented environment is returned.
(defgeneric finalize-binding
    (client builder environment binding-ast declaration-asts))

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


(defmethod finalize-binding
    (client builder environment (ast ico:variable-binding-ast) declaration-asts)
  (let* ((form-ast (ico:form-ast ast))
         (variable-name-ast (ico:variable-name-ast ast))
         (variable-name (ico:name variable-name-ast)))
    (reinitialize-instance ast
      :form-ast (convert-ast builder form-ast))
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
              do (setf new-environment
                       (finalize-binding
                        client
                        builder
                        new-environment
                        binding-ast
                        (ico:declaration-asts ast))))
        (let ((new-builder (make-builder client new-environment)))
              (reinitialize-instance ast
                :form-asts
                (loop for body-ast in (ico:form-asts ast)
                      collect (convert-ast new-builder body-ast)))))))
