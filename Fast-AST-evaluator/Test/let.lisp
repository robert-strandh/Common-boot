(cl:in-package #:common-boot-fast-ast-evaluator-test)

(define-test let)

(define-test let-empty
  :parent let
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ())
         (eval-expression client '#1# environment))))

(define-test let-no-bindings
  :parent let
  (with-default-parameters (client environment global-environment)
    (iss #1=(let () 234)
         (eval-expression client '#1# environment))))

(define-test let-no-bindings-two-forms
  :parent let
  (with-default-parameters (client environment global-environment)
    (iss #1=(let () 234 345)
         (eval-expression client '#1# environment))))

(define-test let-one-binding
  :parent let
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 234)) x)
         (eval-expression client '#1# environment))))

(define-test let-no-initform
  :parent let
  (with-default-parameters (client environment global-environment)
    (iss #1=(let (x) x)
         (eval-expression client '#1# environment))))

(define-test let-nested-binding
  :parent let
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 234)) (let ((x 345) (y x)) (+ x y)))
         (eval-expression client '#1# environment))))

(define-test let-nested-binding-with-side-effect
  :parent let
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 10)) (let ((y 5)) (setq x (+ x y))) x)
         (eval-expression client '#1# environment))))

(define-test let-nested-binding-with-side-effect-inside-block
  :parent let
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 10)) (block b (let ((y 5)) (setq x (+ x y)))) x)
         (eval-expression client '#1# environment))))

(define-test let-with-special-variable
  :parent let
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 234)) (declare (special x)) x)
         (eval-expression client '#1# environment))))

(define-test let-with-ignore-declaration
  :parent let
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 234) (y 345)) (declare (ignore x)) y)
         (eval-expression client '#1# environment))))

(define-test let-with-ignore-declaration-of-second
  :parent let
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 234) (y 345)) (declare (ignore y)) x)
         (eval-expression client '#1# environment))))

(define-test let-with-ignorable-declaration
  :parent let
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 234) (y 345)) (declare (ignorable x)) y)
         (eval-expression client '#1# environment))))

(define-test let-with-ignorable-declaration-of-second
  :parent let
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 234) (y 345)) (declare (ignorable y)) x)
         (eval-expression client '#1# environment))))
