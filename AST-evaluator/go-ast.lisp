(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client environment (ast ico:go-ast) continuation)
  (let* ((tag-reference-ast (ico:tag-ast ast))
         (name (lookup (ico:tag-definition-ast tag-reference-ast))))
    `(let ((*continuation* ,continuation)
           (entry (do-go ',name dynamic-environment)))
       (throw (catch-tag entry) (continuation entry)))))
