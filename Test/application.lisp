(cl:in-package #:common-boot-test)

(define-test application)

(define-test application-no-arguments
  :parent application
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client '+ global-environment)
    (iss #1=(+)
         (cbae:new-eval-expression '#1# environment))))

(define-test application-one-argument
  :parent application
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client '+ global-environment)
    (iss #1=(+ 234)
         (cbae:new-eval-expression '#1# environment))))

(define-test application-two-argument
  :parent application
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client '+ global-environment)
    (iss #1=(+ 234 345)
         (cbae:new-eval-expression '#1# environment))))

(define-test application-multiple-return-values
  :parent application
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client 'floor global-environment)
    (iss #1=(floor 234 33)
         (cbae:new-eval-expression '#1# environment))))
