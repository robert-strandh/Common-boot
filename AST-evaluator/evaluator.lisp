(cl:in-package #:common-boot-ast-evaluator)

(defun evaluator-step ()
  (apply (if (typep *continuation* 'cps-function)
             (cps-entry-point *continuation*)
             *continuation*)
         *arguments*)
  *arguments*)

(defun eval-ast (client ast environment)
  (let* ((global-environment (trucler:global-environment client environment))
         (cps (ast-to-cps client ast environment))
         (initial-continuation (compile nil cps)))
    (setq *dynamic-environment* '())
    (setq *continuation*
          (lambda (&rest arguments)
            (return-from eval-ast arguments)))
    (push-stack)
    (setq *continuation* initial-continuation)
    (setq *arguments* (list client global-environment))
    (loop (evaluator-step))))

(defun eval-cst (cst environment)
  (let* ((client (make-instance 'trucler-reference:client))
         (ast (cb:cst-to-ast client cst environment)))
    (eval-ast client ast environment)))

(defun cps-from-expression (expression environment)
  (let* ((cst (cst:cst-from-expression expression))
         (client (make-instance 'trucler-reference:client))
         (ast (cb:cst-to-ast client cst environment)))
    (ast-to-cps client ast environment)))

(defun ast-from-expression (expression environment)
  (let* ((cst (cst:cst-from-expression expression))
         (client (make-instance 'trucler-reference:client)))
    (cb:cst-to-ast client cst environment)))

(defun eval-expression (expression environment)
  (apply #'values
         (eval-cst (cst:cst-from-expression expression) environment)))
