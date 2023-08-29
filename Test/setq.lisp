(cl:in-package #:common-boot-test)

(define-test setq)

(define-test setq-empty
  :parent setq
  (with-default-parameters (client environment global-environment)
    (is #'equal
        (multiple-value-list #1=(setq))
        (cbae:eval-expression '#1# environment))))

(define-test setq-one-pair
  :parent setq
  (with-default-parameters (client environment global-environment)
    (is #'equal
        (multiple-value-list #1=(let ((x 10)) (setq x 20)))
        (cbae:eval-expression '#1# environment))))

(define-test setq-two-pairs
  :parent setq
  (with-default-parameters (client environment global-environment)
    (is #'equal
        (multiple-value-list #1=(let ((x 10)) (setq x 20 x 30)))
        (cbae:eval-expression '#1# environment))))

(define-test setq-two-pairs-and-return
  :parent setq
  (with-default-parameters (client environment global-environment)
    (is #'equal
        (multiple-value-list #1=(let ((x 10)) (setq x 20 x 30) x))
        (cbae:eval-expression '#1# environment))))
