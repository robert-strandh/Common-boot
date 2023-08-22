(cl:in-package #:common-boot)

(defmethod abp:finish-node (builder kind (ast ico:quote-ast))
  (declare (ignore builder kind))
  nil)
