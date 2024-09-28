(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:return-from-ast))
  (let* ((name-ast (ico:name-ast ast))
         (definition-ast (ico:block-name-definition-ast name-ast))
         (identity (lookup definition-ast environment))
         (entry (do-return-from identity *dynamic-environment*)))
    (funcall
     (unwinder entry)
     (if (null (ico:form-ast ast))
         '()
         (multiple-value-list
          (interpret-ast client environment (ico:form-ast ast)))))))
