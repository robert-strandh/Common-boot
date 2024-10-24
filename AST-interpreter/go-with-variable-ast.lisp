(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast
    (client environment (ast ico:go-with-variable-ast))
  (let* ((variable-reference-ast (ico:variable-reference-ast ast))
         (variable-definition-ast
           (ico:definition-ast variable-reference-ast))
         (identity (lookup variable-definition-ast environment))
         (index-ast (ico:index-ast ast))
         (index (ico:literal index-ast))
         (entry (do-go identity *dynamic-environment*)))
    (funcall (aref (unwinders entry) index))))
