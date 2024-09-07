(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:return-from-ast))
  (let* ((form-ast (ico:form-ast ast))
         (form (translate-ast client environment form-ast))
         (block-name-ast (ico:name-ast ast))
         (name (lookup (ico:block-name-definition-ast block-name-ast))))
    `(let* ((entry (do-return-from ',name dynamic-environment))
            (unwinder (unwinder entry)))
       (funcall unwinder (multiple-value-list ,form)))))