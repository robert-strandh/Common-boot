(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:eval-when-ast))
  (let* ((situation-asts (ico:situation-asts ast))
         (situation-csts (mapcar #'ico:name situation-asts))
         (situations (mapcar #'cst:raw situation-csts)))
    (when (or (member ':execute situations)
              (member 'eval situations))
      (interpret-implicit-progn-asts
       client environment (ico:form-asts ast)))))
