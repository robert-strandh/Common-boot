(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:throw-ast))
  (let* ((form-ast (ico:form-ast ast))
         (form (translate-ast client form-ast))
         (name (translate-ast client (ico:tag-ast ast))))
    `(let* ((entry (do-throw ,name dynamic-environment))
            (unwinder (unwinder entry)))
       (funcall unwinder (multiple-value-list ,form)))))
