(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:assert-ast))
  (reinitialize-instance ast
    :test-form-ast (convert-ast builder (ico:test-form-ast ast))
    :place-asts (convert-asts builder (ico:place-asts ast))
    :argument-form-asts (convert-asts builder (ico:argument-form-asts ast))
    :datum-form-ast (convert-optional-ast builder (ico:datum-form-ast ast))))
