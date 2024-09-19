(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:simple-setq-ast))
  (let* ((variable-name-ast (ico:variable-name-ast ast))
         (variable-definition-ast
           (ico:variable-definition-ast variable-name-ast))
         (value-ast (ico:value-ast ast)))
    (setf (cdr (assoc variable-definition-ast environment))
          (interpret-ast client environment value-ast))))
