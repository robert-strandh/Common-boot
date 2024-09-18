(cl:in-package #:common-boot)

(defun ast-from-expression (expression environment)
  (let* ((cst (cst:cst-from-expression expression))
         (client (make-instance 'trucler-reference:client)))
    (cst-to-ast client cst environment)))

(defun eval-expression (client expression environment)
  (eval-cst client
            (cst:cst-from-expression expression)
            environment))
