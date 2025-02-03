(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:go-with-variable-ast))
  (let* ((variable-reference-ast (ico:variable-reference-ast ast))
         (definition-ast (ico:definition-ast variable-reference-ast))
         (host-name (lookup definition-ast))
         (index (translate-ast client (ico:index-ast ast))))
    `(let* ((entry (do-go ,host-name dynamic-environment)))
       (throw ,host-name ,index))))
