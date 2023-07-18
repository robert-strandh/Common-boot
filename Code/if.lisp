(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:if-ast))
  (reinitialize-instance ast
    :test-ast (convert-ast builder (ico:test-ast ast))
    :then-ast (convert-ast builder (ico:then-ast ast))
    :else-ast
    (if (null (ico:else-ast ast))
        nil
        (convert-ast builder (ico:else-ast ast)))))
