(cl:in-package #:common-boot-fast-ast-evaluator)

(defun create-pair (client variable-name-ast value-ast)
  (if (typep variable-name-ast 'ico:special-variable-reference-ast)
      `(setf (symbol-value
              ',(ico:name variable-name-ast)
              ',(clostrum-sys:variable-cell
                 client
                 environment
                 (ico:name variable-name-ast))
              dynamic-environment)
             ,(translate-ast client value-ast))
      `(setq ,(translate-ast client variable-name-ast)
             ,(translate-ast client value-ast))))

(defmethod translate-ast (client (ast ico:setq-ast))
  `(progn
     ,@(loop for variable-name-ast in (ico:variable-name-asts ast)
             for value-ast in (ico:value-asts ast)
             collect (create-pair client
                                  variable-name-ast value-ast))))
