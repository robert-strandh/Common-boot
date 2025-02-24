(cl:in-package #:common-boot-hir-evaluator-test)

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

(define-test multiple-value-call-with-ignore-declaration
  :parent multiple-value-call
  (with-default-parameters (client environment global-environment)
    (iss #1=(multiple-value-call
                (lambda (&optional x &rest rest)
                  (declare (ignore rest))
                  x)
              234)
         (eval-expression client '#1# environment))))
