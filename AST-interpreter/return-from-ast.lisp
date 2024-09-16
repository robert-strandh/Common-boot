(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:return-from-ast))
  (let* ((name-ast (ico:name-ast ast))
         (definition-ast (ico:block-name-definition-ast name-ast)))
    (do-return-from definition-ast *dynamic-environment*)))
