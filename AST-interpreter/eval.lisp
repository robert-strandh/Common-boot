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
         (ast (iat:assignment-conversion ast))
         (ast (iat:convert-block ast)))
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
