(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:incf-ast))
  (reinitialize-instance ast
    :place-ast (convert-ast builder (ico:place-ast ast))
    :delta-ast (convert-optional-ast builder (ico:delta-ast ast))))
