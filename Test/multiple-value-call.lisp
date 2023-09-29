(cl:in-package #:common-boot-test)

(define-test multiple-value-call)

(define-test multiple-value-call-one-form-one-value
  :parent multiple-value-call
  (with-default-parameters (client environment global-environment)
    (iss #1=(multiple-value-call #'+ (+))
         (eval-expression client '#1# environment))))

(define-test multiple-value-call-one-form-two-values
  :parent multiple-value-call
  (with-default-parameters (client environment global-environment)
    (iss #1=(multiple-value-call #'+ (floor 234 33))
         (eval-expression client '#1# environment))))

(define-test multiple-value-call-two-forms-two-values
  :parent multiple-value-call
  (with-default-parameters (client environment global-environment)
    (iss #1=(multiple-value-call #'+ (floor 234 33) 11)
         (eval-expression client '#1# environment))))
