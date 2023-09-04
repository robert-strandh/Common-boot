(cl:in-package #:common-boot-test)

(define-test if)

(define-test if-false-no-else
  :parent if
  (with-default-parameters (client environment global-environment)
    (iss #1=(if nil 234)
         (cbae:new-eval-expression '#1# environment))))

(define-test if-true-no-else
  :parent if
  (with-default-parameters (client environment global-environment)
    (is #'equal
        (multiple-value-list
         #1=(if 1 234))
        (cbae:eval-expression '#1# environment))))

(define-test if-false-with-else
  :parent if
  (with-default-parameters (client environment global-environment)
    (is #'equal
        (multiple-value-list
         #1=(if nil 234 345))
        (cbae:eval-expression '#1# environment))))

(define-test if-true-with-else
  :parent if
  (with-default-parameters (client environment global-environment)
    (is #'equal
        (multiple-value-list
         #1=(if 1 234 345))
        (cbae:eval-expression '#1# environment))))
