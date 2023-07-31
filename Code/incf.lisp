(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:incf-ast))
  (reinitialize-instance ast
    :place-ast (convert-ast builder (ico:place-ast ast))
    :delta-ast (if (null (ico:delta-ast ast))
                   nil
                   (convert-ast builder (ico:delta-ast ast)))))
