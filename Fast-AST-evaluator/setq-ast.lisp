(cl:in-package #:common-boot-fast-ast-evaluator)

(defun create-pair (client environment variable-name-ast value-ast)
  (if (typep variable-name-ast 'ico:special-variable-reference-ast)
      (let ((global-environment
              (trucler:global-environment client environment)))
        `(setf (symbol-value
                ',(ico:name variable-name-ast)
                ',(clostrum-sys:variable-cell
                   client
                   global-environment
                   (ico:name variable-name-ast))
                dynamic-environment)
               ,(translate-ast client environment value-ast)))
      `(setq ,(translate-ast client environment variable-name-ast)
             ,(translate-ast client environment value-ast))))

(defmethod translate-ast (client environment (ast ico:setq-ast))
  `(progn
     ,@(loop for variable-name-ast in (ico:variable-name-asts ast)
             for value-ast in (ico:value-asts ast)
             collect (create-pair client environment
                                  variable-name-ast value-ast))))
