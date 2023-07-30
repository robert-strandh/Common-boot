(cl:in-package #:common-boot-test)

(define-test application)

(define-test application-no-arguments
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client '+ global-environment)
    (is #'equal
        (multiple-value-list (+))
        (cbae:eval-expression '(+) environment))))
