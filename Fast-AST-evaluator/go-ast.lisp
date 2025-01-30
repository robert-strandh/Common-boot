(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:go-ast))
  (let* ((tag-reference-ast (ico:tag-ast ast))
         (tag-definition-ast (ico:tag-definition-ast tag-reference-ast))
         (host-name (lookup tag-definition-ast)))
    `(let ((entry (do-go ',host-name dynamic-environment)))
       (funcall (unwinder entry)))))
