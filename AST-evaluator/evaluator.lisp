(cl:in-package #:common-boot-ast-evaluator)

(defun evaluator-step ()
  (apply (if (typep *continuation* 'cps-function)
             (cps-entry-point *continuation*)
             *continuation*)
         *arguments*)
  *arguments*)

(defun eval-cst (cst environment)
  (let* ((client (make-instance 'trucler-reference:client))
         (global-environment (trucler:global-environment client environment))
         (ast (cb:cst-to-ast client cst environment))
         (cps (ast-to-cps client ast))
         (initial-continuation (compile nil cps)))
    (setq *dynamic-environment* '())
    (setq *continuation*
          (lambda (&rest arguments)
            (return-from eval-cst arguments)))
    (push-stack)
    (setq *continuation* initial-continuation)
    (setq *arguments* (list client global-environment))
    (loop (evaluator-step))))

(defun cps-from-expression (expression environment)
  (let* ((cst (cst:cst-from-expression expression))
         (client (make-instance 'trucler-reference:client))
         (ast (cb:cst-to-ast client cst environment)))
    (ast-to-cps client ast)))

(defun ast-from-expression (expression environment)
  (let* ((cst (cst:cst-from-expression expression))
         (client (make-instance 'trucler-reference:client)))
    (cb:cst-to-ast client cst environment)))

(defun eval-expression (expression environment)
  (eval-cst (cst:cst-from-expression expression) environment))

(defun new-eval-expression (expression environment)
  (apply #'values
         (eval-cst (cst:cst-from-expression expression) environment)))
