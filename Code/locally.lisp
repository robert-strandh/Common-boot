(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:locally-ast))
  (with-accessors ((declaration-asts ico:declaration-asts))
      ast
    (with-builder-components (builder client environment)
      ;; Compute a new environment to use for the body forms.
      (let ((body-environment environment))
        ;; Add free SPECIAL declarations to body-environment.
        (loop for declaration-ast in declaration-asts
              do (when (typep declaration-ast 'ico:special-ast)
                   (setf body-environment
                         (maybe-augment-environment-with-special-ast
                          client declaration-ast body-environment))))
        (let ((new-builder (make-builder client body-environment)))
          (reinitialize-instance ast
            :form-asts
            (loop for body-ast in (ico:form-asts ast)
                  collect (convert-ast new-builder body-ast))))))))
