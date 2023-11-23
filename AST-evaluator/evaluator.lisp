(cl:in-package #:common-boot-ast-evaluator)

(defun evaluator-step ()
  (apply (if (typep *continuation* 'cps-function)
             (cps-entry-point *continuation*)
             *continuation*)
         *arguments*)
  *arguments*)

(defun simplify-ast (ast)
  (let* ((ast (iat:lexify-lambda-list ast))
         (ast (iat:split-let-or-let* ast))
         (ast (iat:let-to-labels ast)))
    ast))

(defun eval-ast (client ast environment)
  (let* ((transformed-ast (simplify-ast ast))
         (cps (ast-to-cps client transformed-ast environment))
         (initial-continuation
           (let (#+sbcl(sb-ext:*evaluator-mode* :interpret))
             (eval cps))))
    (setq *dynamic-environment* '())
    (setq *continuation*
          (lambda (&rest arguments)
            (return-from eval-ast (apply #'values arguments))))
    (push-stack)
    (setq *continuation* initial-continuation)
    (setq *arguments* '())
    (loop (evaluator-step))))
