(cl:in-package #:common-boot-test)

(define-test block-and-return-from)

(define-test block-no-return-from
  :parent block-and-return-from
  (with-default-parameters (client environment global-environment)
    (is #'equal
        (multiple-value-list #1=(block b 234))
        (cbae:eval-expression '#1# environment))))

(define-test block-with-return-from
  :parent block-and-return-from
  (with-default-parameters (client environment global-environment)
    (is #'equal
        (multiple-value-list #1=(block b (return-from b 345) 234))
        (cbae:eval-expression '#1# environment))))

(define-test block-with-return-from-inside-let
  :parent block-and-return-from
  (with-default-parameters (client environment global-environment)
    (is #'equal
        (multiple-value-list #1=(block b (let () (return-from b 345) 234)))
        (cbae:eval-expression '#1# environment))))
