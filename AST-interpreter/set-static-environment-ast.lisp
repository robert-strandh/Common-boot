(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast
    (client environment (ast ico:set-static-environment-ast))
  (let* ((form-asts (ico:form-asts ast))
         (function-reference-ast (ico:function-reference-ast ast))
         (form-count (length form-asts))
         (static-environment (make-array form-count))
         (closure (interpret-ast client environment function-reference-ast)))
    (loop for form-ast in form-asts
          for index from 0
          do (setf (svref static-environment index)
                   (interpret-ast client environment form-ast)))
    (setf (static-environment closure) static-environment)))
