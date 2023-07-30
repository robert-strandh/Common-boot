(cl:in-package #:common-boot-test)

(define-test application)

(define-test application-no-arguments
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client '+ global-environment)
    (is #'equal
        (multiple-value-list #1=(+))
        (cbae:eval-expression '#1# environment))))

(define-test application-one-argument
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client '+ global-environment)
    (is #'equal
        (multiple-value-list #1=(+ 234))
        (cbae:eval-expression '#1# environment))))

(define-test application-two-argument
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client '+ global-environment)
    (is #'equal
        (multiple-value-list #1=(+ 234 345))
        (cbae:eval-expression '#1# environment))))

(define-test application-multiple-return-values
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client 'floor global-environment)
    (is #'equal
        (multiple-value-list #1=(floor 234 33))
        (cbae:eval-expression '#1# environment))))
