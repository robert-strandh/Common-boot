(cl:in-package #:common-boot-test)

(define-test function)

(define-test function-with-simple-lambda-expression
  :parent function
  (with-default-parameters (client environment global-environment)
    (iss #1=(funcall (function (lambda (x) (1+ x))) 234)
         (eval-expression client '#1# environment))))
