(cl:in-package #:common-boot-test)

(define-test multiple-value-prog1)

(define-test multiple-value-prog1-only-first-form-single-value
  :parent multiple-value-prog1
  (with-default-parameters (client environment global-environment)
    (iss #1=(multiple-value-prog1 234)
         (cbae:new-eval-expression '#1# environment))))

(define-test multiple-value-prog1-only-first-form-two-values
  :parent multiple-value-prog1
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client 'floor global-environment)
    (iss #1=(multiple-value-prog1 (floor 234 33))
         (cbae:new-eval-expression '#1# environment))))

(define-test multiple-value-prog1-one-more-form-single-value
  :parent multiple-value-prog1
  (with-default-parameters (client environment global-environment)
    (iss #1=(multiple-value-prog1 234 11)
         (cbae:new-eval-expression '#1# environment))))

(define-test multiple-value-prog1-one-more-form-two-values
  :parent multiple-value-prog1
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client 'floor global-environment)
    (iss #1=(multiple-value-prog1 (floor 234 33) 11)
         (cbae:new-eval-expression '#1# environment))))
