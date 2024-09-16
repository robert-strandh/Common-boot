(cl:in-package #:common-boot-ast-interpreter-test)

(define-test application)

(define-test application-no-arguments
  :parent application
  (with-default-parameters (client environment global-environment)
    (iss #1=(+)
         (eval-expression client '#1# environment))))

(define-test application-one-argument
  :parent application
  (with-default-parameters (client environment global-environment)
    (iss #1=(+ 234)
         (eval-expression client '#1# environment))))

(define-test application-two-argument
  :parent application
  (with-default-parameters (client environment global-environment)
    (iss #1=(+ 234 345)
         (eval-expression client '#1# environment))))

(define-test application-multiple-return-values
  :parent application
  (with-default-parameters (client environment global-environment)
    (iss #1=(floor 234 33)
         (eval-expression client '#1# environment))))

(define-test application-of-lambda-with-ignore-declaration-of-required
  :parent application
  (with-default-parameters (client environment global-environment)
    (iss #1=((lambda (x)
               (declare (ignore x))
               345)
             234)
         (eval-expression client '#1# environment))))

(define-test application-of-lambda-with-ignore-declaration-of-one-required
  :parent application
  (with-default-parameters (client environment global-environment)
    (iss #1=((lambda (x y)
               (declare (ignore x))
               y)
             234 345)
         (eval-expression client '#1# environment))))

(define-test
    application-of-lambda-with-rest-and-ignore-declaration-of-required
  :parent application
  (with-default-parameters (client environment global-environment)
    (iss #1=((lambda (x &rest rest)
               (declare (ignore x))
               rest)
             234)
         (eval-expression client '#1# environment))))

(define-test
    application-of-lambda-with-optional-and-ignore-declaration-of-required
  :parent application
  (with-default-parameters (client environment global-environment)
    (iss #1=((lambda (x &optional y)
               (declare (ignore x))
               y)
             234)
         (eval-expression client '#1# environment))))

(define-test application-of-lambda-with-optional
  :parent application
  (with-default-parameters (client environment global-environment)
    (iss #1=((lambda (&optional x) x)
             234)
         (eval-expression client '#1# environment))))

(define-test application-of-lambda-with-ignore-declaration-of-optional
  :parent application
  (with-default-parameters (client environment global-environment)
    (iss #1=((lambda (&optional x &rest rest)
               (declare (ignore x))
               rest)
             234)
         (eval-expression client '#1# environment))))

(define-test application-of-lambda-with-ignore-declaration-of-rest
  :parent application
  (with-default-parameters (client environment global-environment)
    (iss #1=((lambda (&optional x &rest rest)
               (declare (ignore rest))
               x)
             234)
         (eval-expression client '#1# environment))))

(define-test application-of-lambda-with-key
  :parent application
  (with-default-parameters (client environment global-environment)
    (iss #1=((lambda (&key x) x)
             :x 234)
         (eval-expression client '#1# environment))))
