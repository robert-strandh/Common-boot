(cl:in-package #:common-boot-ast-evaluator)

(defun ast-to-cps (client ast environment)
  (let* ((variable (gensym))
         (block-variable (gensym))
         (*host-names* (make-hash-table :test #'eq))
         (exit (gensym "EXIT"))
         (global-environment (trucler:global-environment client environment)))
    `(lambda ()
       (block ,block-variable
         (let ((dynamic-environment *dynamic-environment*)
               continuation
               arguments)
           (declare (ignorable dynamic-environment))
           (let ((,exit (make-continuation
                         (lambda (&rest ,variable)
                           (declare (ignore ,variable))
                           (return-from ,block-variable
                             (apply #'values arguments)))
                         :origin ',(ico:origin ast))))
             (step '()
                   (make-continuation
                    (lambda ()
                      ,(cps client global-environment ast exit))
                    :origin ',(ico:origin ast)
                    :next ,exit))
             (trampoline-loop)))))))
