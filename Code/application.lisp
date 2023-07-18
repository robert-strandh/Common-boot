(cl:in-package #:common-boot)

(defmethod abp:finish-node (builder kind (ast ico:application-ast))
  ;; We assume that each argument is an unparsed form.
  (reinitialize-instance ast
    :argument-asts
    (loop for argument-ast in (ico:argument-asts ast)
          collect (convert-ast builder argument-ast))))
