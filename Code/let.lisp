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
                          environment)
                       (declare (ignore globally-p))
                       (change-class variable-name-ast
                                     (if special-p
                                         'ico:special-variable-bound-ast
                                         'ico:variable-definition-ast))))
            ;; FIXME: Also change class of references in declarations.
            ;; FIXME: Also add free declarations.
            (let ((new-builder (make-builder client body-environment)))
              (reinitialize-instance ast
                :form-asts
                (loop for body-ast in (ico:form-asts ast)
                      collect (convert-ast new-builder body-ast))))))))))
