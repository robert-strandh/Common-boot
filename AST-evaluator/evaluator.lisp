(cl:in-package #:common-boot-ast-evaluator)

(defun simplify-ast (ast)
  (let* ((ast (iat:lexify-lambda-list ast))
         (ast (iat:split-let-or-let* ast))
         (ast (iat:replace-special-let-with-bind ast))
         (ast (iat:let-to-labels ast)))
    ast))

(defun compile-ast (client ast environment)
  (setf *dynamic-environment* '()
        *continuation* nil)
  (let* ((transformed-ast (simplify-ast ast))
         (cps (ast-to-cps client transformed-ast environment)))
    (declare (optimize (compilation-speed 3) (debug 0)))
    (eval cps)))
