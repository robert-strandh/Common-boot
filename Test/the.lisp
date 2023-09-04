(cl:in-package #:common-boot-test)

(define-test the)

(define-test the-t
  :parent the
  (with-default-parameters (client environment global-environment)
    (iss #1=(the t 234)
         (eval-expression '#1# environment))))
