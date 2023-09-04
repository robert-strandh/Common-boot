(cl:in-package #:common-boot-test)

(define-test application)

(define-test application-no-arguments
  :parent application
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client '+ global-environment)
    (iss #1=(+)
         (eval-expression '#1# environment))))

(define-test application-one-argument
  :parent application
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client '+ global-environment)
    (iss #1=(+ 234)
         (eval-expression '#1# environment))))

(define-test application-two-argument
  :parent application
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client '+ global-environment)
    (iss #1=(+ 234 345)
         (eval-expression '#1# environment))))

(define-test application-multiple-return-values
  :parent application
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client 'floor global-environment)
    (iss #1=(floor 234 33)
         (eval-expression '#1# environment))))
