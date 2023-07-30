(cl:in-package #:common-boot)

(defmethod abp:finish-node (builder kind (ast ico:quote-ast))
  (declare (ignore builder kind))
  (reinitialize-instance ast
    :object-ast (ico:form (ico:object-ast ast))))
