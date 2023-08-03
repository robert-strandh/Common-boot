(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:psetq-ast))
  (reinitialize-instance ast
    :variable-name-asts
    (convert-asts builder (ico:variable-name-asts ast))
    :value-asts
    (convert-asts builder (ico:value-asts ast))))
