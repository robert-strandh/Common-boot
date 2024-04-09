(cl:in-package #:common-boot-test)

(define-test let*)

(define-test let*-empty
  :parent let*
  (with-default-parameters (client environment global-environment)
    (iss #1=(let* ())
         (eval-expression client '#1# environment))))

(define-test let*-no-bindings
  :parent let*
  (with-default-parameters (client environment global-environment)
    (iss #1=(let* () 234)
         (eval-expression client '#1# environment))))

(define-test let*-no-bindings-two-forms
  :parent let*
  (with-default-parameters (client environment global-environment)
    (iss #1=(let* () 234 345)
         (eval-expression client '#1# environment))))

(define-test let*-one-binding
  :parent let*
  (with-default-parameters (client environment global-environment)
    (iss #1=(let* ((x 234)) x)
         (eval-expression client '#1# environment))))

(define-test let*-no-initform
  :parent let*
  (with-default-parameters (client environment global-environment)
    (iss #1=(let* (x) x)
         (eval-expression client '#1# environment))))

(define-test let*-nested-binding
  :parent let*
  (with-default-parameters (client environment global-environment)
    (iss #1=(let* ((x 234))
              (declare (ignorable x))
              (let* ((x 345) (y x)) (+ x y)))
         (eval-expression client '#1# environment))))

(define-test let*-with-ignore-declaration
  :parent let*
  (with-default-parameters (client environment global-environment)
    (iss #1=(let* ((x 234) (y 345)) (declare (ignore x)) y)
         (eval-expression client '#1# environment))))
