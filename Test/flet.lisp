(cl:in-package #:common-boot-test)

(define-test flet)

(define-test flet-no-parameters
  :parent flet
  (with-default-parameters (client environment global-environment)
    (is #'equal
        (multiple-value-list
         #1=(flet ((f () 234)) (f)))
        (cbae:eval-expression '#1# environment))))

(define-test flet-one-parameters
  :parent flet
  (with-default-parameters (client environment global-environment)
    (is #'equal
        (multiple-value-list
         #1=(flet ((f (x) x)) (f 234)))
        (cbae:eval-expression '#1# environment))))

(define-test flet-nested
  :parent flet
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client '+ global-environment)
    (is #'equal
        (multiple-value-list
         #1=(flet ((f (x) (+ x 1)))
              (flet ((f (x) x)
                     (g (x) (f x)))
                (g 234))))
        (cbae:eval-expression '#1# environment))))
