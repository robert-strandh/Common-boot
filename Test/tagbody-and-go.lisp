(cl:in-package #:common-boot-test)

(define-test tagbody-and-go)

(define-test tagbody-and-go-empty
  :parent tagbody-and-go
  (with-default-parameters (client environment global-environment)
    (iss #1=(tagbody)
         (cbae:eval-expression '#1# environment))))

(define-test tagbody-and-go-no-go
  :parent tagbody-and-go
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 10)) (tagbody (setq x 20)) x)
         (cbae:eval-expression '#1# environment))))

(define-test tagbody-and-go-one-go
  :parent tagbody-and-go
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 10)) (tagbody (go out) (setq x 20) out) x)
         (cbae:eval-expression '#1# environment))))
