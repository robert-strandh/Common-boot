(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:go-ast) continuation)
  (let* ((tag-ast (ico:tag-ast ast))
         (name (lookup (ico:tag-definition-ast tag-ast))))
    `(loop for entry in *dynamic-environment*
           do (when (and (typep entry 'block-entry)
                         (eq ',name (name entry)))
                ;; FIXME: check for expired entry.
                (step '()
                      (continuation entry))))))
