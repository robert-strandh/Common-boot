(cl:in-package #:common-boot-test)

(define-test application)

(define-test application-no-arguments
  :parent application
  (with-default-parameters (client environment global-environment)
    (iss #1=(+)
         (eval-expression client '#1# environment))))

(define-test application-one-argument
  :parent application
  (with-default-parameters (client environment global-environment)
    (iss #1=(+ 234)
         (eval-expression client '#1# environment))))

(define-test application-two-argument
  :parent application
  (with-default-parameters (client environment global-environment)
    (iss #1=(+ 234 345)
         (eval-expression client '#1# environment))))

(define-test application-multiple-return-values
  :parent application
  (with-default-parameters (client environment global-environment)
    (iss #1=(floor 234 33)
         (eval-expression client '#1# environment))))
