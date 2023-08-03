(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:assert-ast))
  (reinitialize-instance ast
    :test-form-ast (convert-ast builder (ico:test-form-ast ast))
    :place-asts
    (loop for place-ast in (ico:place-asts ast)
          collect (convert-ast builder place-ast))
    :argument-form-asts
    (loop for argument-form-ast in (ico:argument-form-asts ast)
          collect (convert-ast builder argument-form-ast))
    :datum-form-ast (if (null (ico:datum-form-ast ast))
                        nil
                        (convert-ast builder (ico:datum-form-ast ast)))))
