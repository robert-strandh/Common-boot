(cl:in-package #:common-boot)

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
      (let ((variable-name-asts
              (mapcar #'ico:variable-name-ast binding-asts))
            (declaration-specifier-asts
              (reduce #'append
                      (mapcar #'ico:declaration-specifier-asts
                              declaration-asts)
                      :from-end t)))
        (multiple-value-bind (bound-declarations-asts
                              remaining-declaration-asts)
            (associate-declaration-specifier-asts
             declaration-specifier-asts variable-name-asts)
          ;; Next, compute a new environment to use for the body
          ;; forms.
          (let ((body-environment environment))
            (loop for variable-name-ast in variable-name-asts
                  for bound-declaration-asts in bound-declarations-asts
                  do (setf body-environment
                           (augment-environment-with-variable
                            client
                            variable-name-ast
                            bound-declaration-asts
                            body-environment))
                     (multiple-value-bind (special-p globally-p)
                         (variable-is-special-p
                          client
                          variable-name-ast
                          bound-declaration-asts
                          body-environment)
                       (declare (ignore globally-p))
                       (change-class variable-name-ast
                                     (if special-p
                                         'ico:special-variable-bound-ast
                                         'ico:variable-definition-ast)))
                     (change-class-of-variable-references
                      variable-name-ast bound-declaration-asts))
            ;; Add free SPECIAL declarations to body-environment.
            (loop for declaration-ast in remaining-declaration-asts
                  do (when (typep declaration-ast
                                  'ico:special-ast)
                       (setf body-environment
                             (maybe-augment-environment-with-special-ast
                              client declaration-ast body-environment))))
            (let ((new-builder (make-builder client body-environment)))
              (reinitialize-instance ast
                :form-asts
                (loop for body-ast in (ico:form-asts ast)
                      collect (convert-ast new-builder body-ast))))))))))
