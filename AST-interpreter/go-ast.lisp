(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:go-ast))
  (let* ((tag-reference-ast (ico:tag-ast ast))
         (tag-definition-ast (ico:tag-definition-ast tag-reference-ast))
         (entry (do-go tag-definition-ast *dynamic-environment*)))
    (funcall (unwinder entry))))
