(cl:in-package #:common-boot-fast-ast-evaluator-test)

(define-test the)

(define-test the-t
  :parent the
  (with-default-parameters (client environment global-environment)
    (iss #1=(the t 234)
         (eval-expression client '#1# environment))))
