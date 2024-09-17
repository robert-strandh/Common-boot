(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:throw-ast))
  (let ((entry (do-throw (ico:tag-ast ast) *dynamic-environment*)))
    (funcall (unwinder entry)
             (multiple-value-list
              (interpret-ast client environment (ico:form-ast ast))))))
