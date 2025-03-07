(cl:in-package #:common-boot-hir-evaluator-test)

(define-test quote)

(define-test quote-with-number
  :parent quote
  (with-default-parameters (client environment global-environment)
    (iss #1=(quote 234)
         (eval-expression client '#1# environment))))

(define-test quote-with-symbol
  :parent quote
  (with-default-parameters (client environment global-environment)
    (iss #1=(quote hello)
         (eval-expression client '#1# environment))))
