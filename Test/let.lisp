(cl:in-package #:common-boot-test)

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

(define-test let-one-binding
  :parent let
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((x 234)) x)
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
