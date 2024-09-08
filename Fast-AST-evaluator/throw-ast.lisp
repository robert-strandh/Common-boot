(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:throw-ast))
  (let* ((form-ast (ico:form-ast ast))
         (form (translate-ast client environment form-ast))
         (name (translate client environment (ico:tag-ast ast))))
    `(let* ((entry (do-throw ',name dynamic-environment))
            (unwinder (unwinder entry)))
       (funcall unwinder (multiple-value-list ,form)))))
