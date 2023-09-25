(cl:in-package #:common-boot-test)

(define-test labels)

(define-test labels-no-parameters
  :parent labels
  (with-default-parameters (client environment global-environment)
    (iss #1=(labels ((f () 234)) (f))
         (eval-expression '#1# environment))))

(define-test labels-one-parameter
  :parent labels
  (with-default-parameters (client environment global-environment)
    (iss #1=(labels ((f (x) x)) (f 234))
         (eval-expression '#1# environment))))

(define-test labels-nested
  :parent labels
  (with-default-parameters (client environment global-environment)
    (iss #1=(labels ((f (x) (+ x 1)))
              (labels ((f (x) x)
                       (g (x) (f x)))
                (g 234)))
         (eval-expression '#1# environment))))
