(cl:in-package #:common-boot-fast-ast-evaluator-test)

(define-test flet)

(define-test flet-no-parameters
  :parent flet
  (with-default-parameters (client environment global-environment)
    (iss #1=(flet ((f () 234)) (f))
         (eval-expression client '#1# environment))))

(define-test flet-no-parameters-two-body-forms
  :parent flet
  (with-default-parameters (client environment global-environment)
    (iss #1=(flet ((f () 234 345)) (f))
         (eval-expression client '#1# environment))))

(define-test flet-one-parameter
  :parent flet
  (with-default-parameters (client environment global-environment)
    (iss #1=(flet ((f (x) x)) (f 234))
         (eval-expression client '#1# environment))))

(define-test flet-nested
  :parent flet
  (with-default-parameters (client environment global-environment)
    (iss #1=(flet ((f (x) (+ x 1)))
              (flet ((f (x) x)
                     (g (x) (f x)))
                (g 234)))
         (eval-expression client '#1# environment))))

(define-test flet-with-return-from
  :parent flet
  (with-default-parameters (client environment global-environment)
    (iss #1=(flet ((f () (return-from f 234))) (f))
         (eval-expression client '#1# environment))))

(define-test flet-with-function
  :parent flet
  (with-default-parameters (client environment global-environment)
    (iss #1=(flet ((f () 234)) (funcall (function f)))
         (eval-expression client '#1# environment))))

(define-test flet-with-two-functions-and-function
  :parent flet
  (with-default-parameters (client environment global-environment)
    (iss #1=(flet ((f () 234)
                   (g () 345))
              (declare (ignore (function g)))
              (funcall (function f)))
         (eval-expression client '#1# environment))))
