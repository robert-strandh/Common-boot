(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:go-ast) continuation)
  (let* ((tag-reference-ast (ico:tag-ast ast))
         (name (lookup (ico:tag-definition-ast tag-reference-ast))))
    `(do-go ',name dynamic-environment)))
