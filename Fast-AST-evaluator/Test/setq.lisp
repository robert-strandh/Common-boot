(cl:in-package #:common-boot-fast-ast-evaluator-test)

(define-test setq)

(define-test setq-empty
  :parent setq
  (with-default-parameters (client environment global-environment)
    (iss #1=(setq)
         (eval-expression client '#1# environment))))

(define-test setq-one-pair
  :parent setq
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 10)) (setq x 20))
         (eval-expression client '#1# environment))))

(define-test setq-two-pairs
  :parent setq
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 10)) (setq x 20 x 30))
         (eval-expression client '#1# environment))))

(define-test setq-two-pairs-and-return
  :parent setq
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 10)) (setq x 20 x 30) x)
         (eval-expression client '#1# environment))))
