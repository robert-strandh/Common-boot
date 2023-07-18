(cl:in-package #:common-boot)

(defmethod abp:finish-node (builder kind (ast ico:application-ast))
  ;; We assume that each argument is an unparsed form.
  (reinitialize-instance ast
    :argument-asts
    (with-builder-components (builder client environment)
      (loop for argument-ast in (ico:argument-asts ast)
            for cst = (ses:unparse builder t argument-ast)
            collect (convert client cst environment)))))
