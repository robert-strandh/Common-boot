(cl:in-package #:common-boot-ast-interpreter)

(defgeneric interpret-ast (client environment ast))

(defun simplify-ast (ast)
  (let* ((ast (iat:macrolet-to-locally ast))
         (ast (iat:lexify-lambda-list ast))
         (ast (iat:split-let-or-let* ast))
         (ast (iat:replace-special-let-with-bind ast))
         (ast (iat:let-to-labels ast))
         (ast (iat:flet-to-labels ast))
         (ast (iat:split-setq ast))
         (ast (iat:inline-inlinable-functions ast))
         (ast (iat:remove-degenerate-labels ast))
         (ast (iat:assignment-conversion ast))
         (ast (iat:convert-block ast))
         (ast (iat:remove-unused-blocks ast))
         (ast (iat:convert-tagbody ast))
         (ast (iat:transform-function-definition-and-reference ast))
         (ast (iat:eliminate-function ast))
         (ast (iat:closure-conversion ast))
         (ast (iat:replace-trivial-locally-by-progn ast))
         (ast (iat:eliminate-trivial-progn ast)))
    ast))

(defun interpret (client ast)
  (interpret-ast client '() ast))

(defmethod cb:eval-cst ((client client) cst environment)
  (let* ((ast (cb:cst-to-ast client cst environment))
         (simplified-ast (simplify-ast ast))
         (global-environment
           (trucler:global-environment client environment))
         (cells-ast
           (introduce-cells client global-environment simplified-ast)))
    (interpret client cells-ast)))

(defun compile-ast (client ast environment)
  (let* ((simplified-ast (simplify-ast ast))
         (global-environment
           (trucler:global-environment client environment))
         (cells-ast
           (introduce-cells client global-environment simplified-ast)))
    (lambda ()
      (interpret client cells-ast))))
