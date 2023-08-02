(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:pushnew-ast))
  (reinitialize-instance ast
    :item-ast (convert-ast builder (ico:item-ast ast))
    :place-ast (convert-ast builder (ico:place-ast ast))
    :key-ast (if (null (ico:key-ast ast))
                 nil
                 (convert-ast builder (ico:key-ast ast)))
    :test-ast (if (null (ico:test-ast ast))
                  nil
                  (convert-ast builder (ico:test-ast ast)))
    :test-not-ast (if (null (ico:test-not-ast ast))
                      nil
                      (convert-ast builder (ico:test-not-ast ast)))))
