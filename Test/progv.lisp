(cl:in-package #:common-boot-test)

(define-test progv)

(define-test progv-no-symbols-no-values
  :parent progv
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 10))
              (declare (special x))
              (progv '() '() x))
         (eval-expression client '#1# environment))))

(define-test progv-one-symbol-one-value
  :parent progv
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 10))
              (declare (special x))
              (progv '(x) '(234)) x)
         (eval-expression client '#1# environment))))
