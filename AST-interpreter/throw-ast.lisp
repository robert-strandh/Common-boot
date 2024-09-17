(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:throw-ast))
  (let* ((tag-ast (ico:tag-ast ast))
         (tag (interpret-ast client environment tag-ast))
         (entry (do-throw tag *dynamic-environment*)))
    (funcall (unwinder entry)
             (multiple-value-list
              (interpret-ast client environment (ico:form-ast ast))))))
