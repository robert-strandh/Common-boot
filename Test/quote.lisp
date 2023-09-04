(cl:in-package #:common-boot-test)

(define-test quote)

(define-test quote-with-number
  :parent quote
  (with-default-parameters (client environment global-environment)
    (iss #1=(quote 234)
         (cbae:eval-expression '#1# environment))))

(define-test quote-with-symbol
  :parent quote
  (with-default-parameters (client environment global-environment)
    (iss #1=(quote hello)
         (cbae:eval-expression '#1# environment))))
