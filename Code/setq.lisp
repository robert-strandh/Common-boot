(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:setq-ast))
  (let ((value-asts (ico:value-asts ast))
        (variable-name-asts (ico:variable-name-asts ast)))
    (with-builder-components (builder client environment)
      (loop for variable-name-ast in variable-name-asts
            do (finalize-variable-name-ast-from-environment
                client variable-name-ast environment))
      (reinitialize-instance ast
        :value-asts
        (loop for value-ast in value-asts
              collect (convert-ast builder value-ast))))))
