(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:define-symbol-macro-ast))
  (reinitialize-instance ast
    :expansion-ast (convert-ast builder (ico:expansion-ast ast))))
