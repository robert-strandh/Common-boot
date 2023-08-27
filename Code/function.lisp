(cl:in-package #:common-boot)

(defmethod abp:finish-node (builder kind (ast ico:function-ast))
  (with-builder-components (builder client environment)
    (finalize-function-name-ast-from-environment
     client (ico:name-ast ast) environment))
  ast)
