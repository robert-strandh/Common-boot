(cl:in-package #:common-boot-ast-interpreter)

(defvar *global-environment*)

(defgeneric interpret-ast (client environment ast))

(defun simplify-ast (ast)
  (let* ((ast (iat:lexify-lambda-list ast))
         (ast (iat:split-let-or-let* ast))
         (ast (iat:replace-special-let-with-bind ast))
         (ast (iat:let-to-labels ast))
         (ast (iat:flet-to-labels ast)))
    ast))

(defun interpret (client ast global-environment)
  (let ((*global-environment* global-environment))
    (interpret-ast client '() (simplify-ast ast))))

(defmethod cb:eval-cst ((client client) cst environment)
  (let* ((ast (cb:cst-to-ast client cst environment))
         (simplified-ast (simplify-ast ast)))
    (interpret client simplified-ast environment)))