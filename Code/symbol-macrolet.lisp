(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:symbol-macrolet-ast))
  (with-builder-components (builder client environment)
    (let ((new-environment environment))
      (loop for symbol-expansion-ast in (ico:symbol-expansion-asts ast)
            for symbol-ast = (ico:symbol-ast symbol-expansion-ast)
            for expansion-ast = (ico:expansion-ast ast)
            do (setf new-environment
                     (augment-environment-with-local-symbol-macro
                      client symbol-ast environment expansion-ast)))
      (reinitialize-instance ast
        :form-asts
        (loop for form-ast in (ico:form-asts ast)
              collect
              (convert-ast-in-environment
               client form-ast new-environment))))))
