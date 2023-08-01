(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:defgeneric-ast))
  (change-class (ico:name-ast ast) 'ico:global-function-name-definition-ast))
