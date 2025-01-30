(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast
    (client (ast ico:return-from-with-variable-ast))
  (let* ((form-ast (ico:form-ast ast))
         (form (if (null form-ast)
                   nil
                   (translate-ast client form-ast)))
         (variable-reference-ast (ico:variable-reference-ast ast))
         (definition-ast
           (ico:definition-ast variable-reference-ast))
         (identity (lookup definition-ast)))
    `(let ((entry (do-return-from ',identity dynamic-environment))
           (unwinder (unwinder entry)))
       (funcall unwinder
                ,(if (null form)
                     '()
                     `(multiple-value-list ,form))))))
