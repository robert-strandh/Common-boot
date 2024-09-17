(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:eval-when-ast))
  (let* ((situation-asts (ico:situation-asts ast))
         (situations (mapcar #'ico:name situation-asts)))
    (when (or (member ':compile-toplevel situations)
              (member 'compile situations))
      (interpret-implicit-progn-asts
       client environment (ico:form-asts ast)))))
