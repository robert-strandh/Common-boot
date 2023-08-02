(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:multiple-value-setq-ast))
  (reinitialize-instance ast
    :value-asts (convert-ast builder (ico:value-ast ast))))
