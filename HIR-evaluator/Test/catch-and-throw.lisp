(cl:in-package #:common-boot-hir-evaluator-test)

(define-test catch-and-throw)

(define-test catch-and-throw-no-throw
  :parent catch-and-throw
  (with-default-parameters (client environment global-environment)
    (iss #1=(catch 'hello (+ 3 4))
         (eval-expression client '#1# environment))))

(define-test catch-and-throw-with-throw
  :parent catch-and-throw
  (with-default-parameters (client environment global-environment)
    (iss #1=(catch 'hello (throw 'hello 234) (+ 3 4))
         (eval-expression client '#1# environment))))
