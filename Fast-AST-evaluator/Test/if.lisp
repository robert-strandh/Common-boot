(cl:in-package #:common-boot-fast-ast-evaluator-test)

(define-test if)

(define-test if-false-no-else
  :parent if
  (with-default-parameters (client environment global-environment)
    (iss #1=(if nil 234)
         (eval-expression client '#1# environment))))

(define-test if-true-no-else
  :parent if
  (with-default-parameters (client environment global-environment)
    (iss #1=(if 1 234)
         (eval-expression client '#1# environment))))

(define-test if-false-with-else
  :parent if
  (with-default-parameters (client environment global-environment)
    (iss #1=(if nil 234 345)
         (eval-expression client '#1# environment))))

(define-test if-true-with-else
  :parent if
  (with-default-parameters (client environment global-environment)
    (iss #1=(if 1 234 345)
         (eval-expression client '#1# environment))))
