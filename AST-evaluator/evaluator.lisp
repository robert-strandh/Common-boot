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
    (setq *continuation*
          (lambda (&rest arguments)
            (declare (ignore arguments))
            (throw 'a *arguments*)))
    (push-stack)
    (setq *continuation* initial-continuation)
    (setq *dynamic-environment* '())
    (setq *arguments* (list client global-environment))
    (catch 'a (loop (evaluator-step)))))

(defun eval-expression (expression environment)
  (eval-cst (cst:cst-from-expression expression) environment))
