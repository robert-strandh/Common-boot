(cl:in-package #:common-boot-test)

(define-test macrolet)

(define-test macrolet-one-macro
  :parent macrolet
  (with-default-parameters (client environment global-environment)
    (iss #1=(macrolet ((foo (x) `(1+ ,x))) (foo 234))
         (eval-expression client '#1# environment))))
