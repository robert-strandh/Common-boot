(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:setq-ast))
  (loop with value = nil
        for variable-name-ast in (ico:variable-name-asts ast)
        for value-ast in (ico:value-asts ast)
        do (if (typep variable-name-ast 'ico:special-variable-reference-ast)
               (setf (symbol-value
                      (ico:name variable-name-ast)
                      (clostrum-sys:variable-cell
                       client
                       (trucler:global-environment 
                        client *global-environment*)
                       (ico:name variable-name-ast))
                      *dynamic-environment*)
                     (setq value 
                           (interpret-ast client environment value-ast)))
               (let ((variable-definition-ast
                       (ico:variable-definition-ast variable-name-ast)))
                 (setf (cdr (assoc variable-definition-ast environment))
                       (setq value 
                             (interpret-ast
                              client environment value-ast)))))
        finally (return value)))
