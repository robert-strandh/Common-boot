(cl:in-package #:common-boot-test)

(define-test progn)

(define-test progn-empty
  :parent progn
  (with-default-parameters (client environment global-environment)
    (is #'equal
        (multiple-value-list #1=(progn))
        (cbae:eval-expression '#1# environment))))

(define-test progn-one-form-number
  :parent progn
  (with-default-parameters (client environment global-environment)
    (is #'equal
        (multiple-value-list #1=(progn 234))
        (cbae:eval-expression '#1# environment))))

(define-test progn-one-two-forms
  :parent progn
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client '+ global-environment)
    (is #'equal
        (multiple-value-list #1=(progn (+ 234) 345))
        (cbae:eval-expression '#1# environment))))
