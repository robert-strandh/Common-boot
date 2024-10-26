(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast
    (client environment (ast ico:read-static-environment-ast))
  (let* ((static-environment-ast (ico:static-environment-ast ast))
         (static-environment
           (interpret-ast client environment static-environment-ast))
         (index-ast (ico:index-ast ast))
         (index (interpret-ast client environment index-ast)))
    (svref static-environment index)))
