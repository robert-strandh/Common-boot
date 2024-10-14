(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast
    (client environment (ast ico:return-from-with-variable-ast))
  (let* ((variable-reference-ast (ico:variable-reference-ast ast))
         (definition-ast
           (ico:variable-definition-ast variable-reference-ast))
         (identity (lookup definition-ast environment))
         (entry (do-return-from identity *dynamic-environment*)))
    (funcall
     (unwinder entry)
     (if (null (ico:form-ast ast))
         '()
         (multiple-value-list
          (interpret-ast client environment (ico:form-ast ast)))))))
