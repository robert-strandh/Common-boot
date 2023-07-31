(cl:in-package #:common-boot-test)

(define-test flet)

(define-test flet-no-parameters
  :parent flet
  (with-default-parameters (client environment global-environment)
    (is #'equal
        (multiple-value-list
         #1=(flet ((f () 234)) (f)))
        (cbae:eval-expression '#1# environment))))
