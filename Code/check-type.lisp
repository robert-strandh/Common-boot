(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:check-type-ast))
  (reinitialize-instance ast
    :place-ast (convert-ast builder (ico:place-ast ast))))
