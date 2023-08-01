(cl:in-package #:common-boot-test)

(define-test multiple-value-call)

(define-test multiple-value-call-one-form-one-value
  :parent multiple-value-call
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client '+ global-environment)
    (is #'equal
        (multiple-value-list
         #1=(multiple-value-call #'+ (+)))
        (cbae:eval-expression '#1# environment))))

(define-test multiple-value-call-one-form-two-value
  :parent multiple-value-call
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client '+ global-environment)
    (cbae:import-host-function client 'floor global-environment)
    (is #'equal
        (multiple-value-list
         #1=(multiple-value-call #'+ (floor 234 33)))
        (cbae:eval-expression '#1# environment))))

(define-test multiple-value-call-two-forms-two-value
  :parent multiple-value-call
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client '+ global-environment)
    (cbae:import-host-function client 'floor global-environment)
    (is #'equal
        (multiple-value-list
         #1=(multiple-value-call #'+ (floor 234 33) 11))
        (cbae:eval-expression '#1# environment))))