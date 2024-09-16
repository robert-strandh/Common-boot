(cl:in-package #:common-boot-ast-interpreter-test)

(define-test labels)

(define-test labels-no-parameters
  :parent labels
  (with-default-parameters (client environment global-environment)
    (iss #1=(labels ((f () 234)) (f))
         (eval-expression client '#1# environment))))

(define-test labels-no-parameters-two-body-forms
  :parent labels
  (with-default-parameters (client environment global-environment)
    (iss #1=(labels ((f () 234 345)) (f))
         (eval-expression client '#1# environment))))

(define-test labels-one-parameter
  :parent labels
  (with-default-parameters (client environment global-environment)
    (iss #1=(labels ((f (x) x)) (f 234))
         (eval-expression client '#1# environment))))

(define-test labels-nested
  :parent labels
  (with-default-parameters (client environment global-environment)
    (iss #1=(labels ((f (x) (+ x 1)))
              (labels ((f (x) x)
                       (g (x) (f x)))
                (g 234)))
         (eval-expression client '#1# environment))))

(define-test labels-with-return-from
  :parent labels
  (with-default-parameters (client environment global-environment)
    (iss #1=(labels ((f () (return-from f 234))) (f))
         (eval-expression client '#1# environment))))

(define-test labels-recursive
  :parent labels
  (with-default-parameters (client environment global-environment)
    (iss #1=(labels ((f (x) (if (null x) 234 (f nil)))) (f 0))
         (eval-expression client '#1# environment))))
