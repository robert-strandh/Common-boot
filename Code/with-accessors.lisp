(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:with-accessors-ast))
  (reinitialize-instance ast
    :instance-form-ast (convert-ast builder (ico:instance-form-ast ast)))
  (with-builder-components (builder client environment)
    (let ((new-environment environment))
      (loop for slot-entry-ast in (ico:slot-entry-asts ast)
            for variable-name-ast = (ico:variable-name-ast slot-entry-ast)
            for accessor-name-ast = (ico:accessor-name-ast slot-entry-ast)
            for new-accessor-name-ast
              = (convert-ast builder accessor-name-ast)
            do (setf new-environment
                     (augment-environment-with-binding-variable
                      client
                      new-environment
                      variable-name-ast
                      (ico:declaration-asts ast)))
               (reinitialize-instance slot-entry-ast
                 :accessor-name-ast new-accessor-name-ast))
      (let ((new-builder (make-builder client new-environment)))
        (reinitialize-instance ast
          :form-asts
          (loop for body-ast in (ico:form-asts ast)
                collect (convert-ast new-builder body-ast)))))))
