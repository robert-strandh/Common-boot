(cl:in-package #:common-boot-fast-ast-evaluator-test)

(define-test progn)

(define-test progn-empty
  :parent progn
  (with-default-parameters (client environment global-environment)
    (iss #1=(progn)
         (eval-expression client '#1# environment))))

(define-test progn-one-form-number
  :parent progn
  (with-default-parameters (client environment global-environment)
    (iss #1=(progn 234)
         (eval-expression client '#1# environment))))

(define-test progn-two-forms
  :parent progn
  (with-default-parameters (client environment global-environment)
    (iss #1=(progn (+ 234) 345)
         (eval-expression client '#1# environment))))
