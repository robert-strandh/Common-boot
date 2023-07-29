(cl:in-package #:common-boot-ast-evaluator)

(defun evaluator-step ()
  (apply *continuation* *arguments*)
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

(defun eval-expression (expression environment)
  (eval-cst (cst:cst-from-expression expression) environment))
