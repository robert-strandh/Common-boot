(cl:in-package #:common-boot-test)

(define-test locally)

(define-test locally-empty
  :parent locally
  (with-default-parameters (client environment global-environment)
    (iss #1=(locally)
         (cbae:eval-expression '#1# environment))))

(define-test locally-with-literal
  :parent locally
  (with-default-parameters (client environment global-environment)
    (iss #1=(locally 234)
         (cbae:eval-expression '#1# environment))))
