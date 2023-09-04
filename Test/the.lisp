(cl:in-package #:common-boot-test)

(define-test the)

(define-test the-t
  :parent the
  (with-default-parameters (client environment global-environment)
    (iss #1=(the t 234)
         (cbae:new-eval-expression '#1# environment))))
