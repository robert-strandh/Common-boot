(cl:in-package #:common-boot-test)

(define-test let)

(define-test let-empty
  :parent let
  (with-default-parameters (client environment global-environment)
    (is #'equal
        (multiple-value-list #1=(let ()))
        (cbae:eval-expression '#1# environment))))

(define-test let-no-bindings
  :parent let
  (with-default-parameters (client environment global-environment)
    (is #'equal
        (multiple-value-list #1=(let () 234))
        (cbae:eval-expression '#1# environment))))

(define-test let-one-binding
  :parent let
  (with-default-parameters (client environment global-environment)
    (is #'equal
        (multiple-value-list #1=(let ((x 234)) x))
        (cbae:eval-expression '#1# environment))))

(define-test let-nested-binding
  :parent let
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client '+ global-environment)
    (is #'equal
        (multiple-value-list
         #1=(let ((x 234)) (let ((x 345) (y x)) (+ x y))))
        (cbae:eval-expression '#1# environment))))
