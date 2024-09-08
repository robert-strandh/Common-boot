(cl:in-package #:common-boot-fast-ast-evaluator-test)

(define-test progv)

(define-test progv-no-symbols-no-values
  :parent progv
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 10))
              (declare (special x))
              (progv '() '() x))
         (eval-expression client '#1# environment))))

(define-test progv-one-symbol-one-value-outside
  :parent progv
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 10))
              (declare (special x))
              (progv '(x) '(234)) x)
         (eval-expression client '#1# environment))))

(define-test progv-one-symbol-one-value-inside
  :parent progv
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 10))
              (declare (special x))
              (progv '(x) '(234) x))
         (eval-expression client '#1# environment))))
