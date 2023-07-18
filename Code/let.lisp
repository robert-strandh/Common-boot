(cl:in-package #:common-boot)

;;; FIXME: handle more declarations
(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:let-ast))
  (with-accessors ((binding-asts ico:binding-asts)
                   (declaration-asts ico:declaration-asts))
      ast
    (with-builder-components (builder client environment)
      ;; Start by converting the initialization arguments of each
      ;; binding, using the original builder.
      (loop for binding-ast in binding-asts
            for form-ast = (ico:form-ast binding-ast)
            do (reinitialize-instance binding-ast
                 :form-ast (convert-ast builder form-ast)))
      ;; Next, compute a new environment to use for the body forms
      (let ((body-environment environment))
        (loop for binding-ast in binding-asts
              for variable-name-ast = (ico:variable-name-ast binding-ast)
              for variable-name = (ico:name variable-name-ast)
              do (multiple-value-bind (special-p globally-special-p)
                     (variable-is-special-p
                      client
                      environment
                      variable-name-ast
                      declaration-asts)
                   (change-class variable-name-ast
                                 (if special-p
                                     'ico:special-variable-bound-ast
                                     'ico:variable-definition-ast))
               (setf body-environment
                     (if special-p
                         (unless globally-special-p
                           (trucler:add-local-special-variable
                            client environment variable-name))
                         (trucler:add-lexical-variable
                          client environment
                          variable-name variable-name-ast)))))
        (let ((new-builder (make-builder client body-environment)))
          (reinitialize-instance ast
            :form-asts
            (loop for body-ast in (ico:form-asts ast)
                  collect (convert-ast new-builder body-ast))))))))
