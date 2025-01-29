(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast
    (client environment (ast ico:read-static-environment-ast))
  (let ((static-environment-ast (ico:static-environment-ast ast))
        (index-ast (ico:index-ast ast)))
    `(svref ,(translate-ast client environment static-environment-ast)
            ,(translate-ast client environment index-ast))))
