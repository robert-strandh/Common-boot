(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast
    (client environment (ast ico:set-static-environment-ast))
  (let* ((form-asts (ico:form-asts ast))
         (function-reference-ast (ico:function-reference-ast ast))
         (form-count (length form-asts)))
    `(let ((static-environment (make-array ,form-count))
           (closure ,(translate-ast client environment function-reference-ast)))
       ,@(loop for form-ast in form-asts
               for index from 0
               collect `(setf (svref static-environment ,index)
                              ,(translate-ast client environment form-ast)))
       (setf (static-environment closure) static-environment))))

