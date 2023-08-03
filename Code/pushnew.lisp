(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:pushnew-ast))
  (reinitialize-instance ast
    :item-ast (convert-ast builder (ico:item-ast ast))
    :place-ast (convert-ast builder (ico:place-ast ast))
    :key-ast (convert-optional-ast builder (ico:key-ast ast))
    :test-ast (convert-optional-ast builder (ico:test-ast ast))
    :test-not-ast (convert-optional-ast builder (ico:test-not-ast ast))))
