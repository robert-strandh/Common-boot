(cl:in-package #:common-boot)

;;; FIXME: handle more declarations
(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:let*-ast))
  (let ((new-builder builder))
    (loop for binding-ast in (ico:binding-asts ast)
          do (with-builder-components (new-builder client environment)
               (setf new-builder
                     (make-builder
                      client
                      (finalize-binding
                       client
                       new-builder
                       environment
                       binding-ast
                       (ico:declaration-asts ast))))))
    (reinitialize-instance ast
      :form-asts
      (loop for body-ast in (ico:form-asts ast)
            collect (convert-ast new-builder body-ast)))))
