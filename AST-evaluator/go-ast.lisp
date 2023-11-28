(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client environment (ast ico:go-ast) continuation)
  (let* ((tag-reference-ast (ico:tag-ast ast))
         (name (lookup (ico:tag-definition-ast tag-reference-ast))))
    `(let ((entry (do-go ',name dynamic-environment)))
       (setf continuation (continuation entry))
       (throw (catch-tag entry) nil))))
