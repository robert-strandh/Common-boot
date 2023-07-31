(cl:in-package #:common-boot-test)

(define-test the)

(define-test the-t
  :parent the
  (with-default-parameters (client environment global-environment)
    (is #'equal
        (multiple-value-list #1=(the t 234))
        (cbae:eval-expression '#1# environment))))
