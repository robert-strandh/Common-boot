(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:print-unreadable-object-ast))
  (reinitialize-instance ast
    :object-ast (convert-ast builder (ico:object-ast ast))
    :stream-ast (convert-ast builder (ico:stream-ast ast))
    :type-ast (convert-optional-ast builder (ico:type-ast ast))
    :identity-ast (convert-optional-ast builder (ico:identity-ast ast))))

