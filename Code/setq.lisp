(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:setq-ast))
  (let ((value-asts (ico:value-asts ast))
        (variable-name-asts (ico:variable-name-asts ast)))
    (reinitialize-instance ast
      :variable-name-asts
      (loop for variable-name-ast in variable-name-asts
            collect (convert-ast builder variable-name-ast))
      :value-asts
      (loop for value-ast in value-asts
            collect (convert-ast builder value-ast)))))
