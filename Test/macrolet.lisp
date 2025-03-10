(cl:in-package #:common-boot-test)

(define-test macrolet)

(define-test macrolet-one-very-simple-macro
  :parent macrolet
  (with-default-parameters (client environment global-environment)
    (iss #1=(macrolet ((foo () 234)) (foo))
         (eval-expression client '#1# environment))))

(define-test macrolet-one-very-simple-macro-two-forms
  :parent macrolet
  (with-default-parameters (client environment global-environment)
    (iss #1=(macrolet ((foo () 234 345)) (foo))
         (eval-expression client '#1# environment))))

(define-test macrolet-one-simple-macro
  :parent macrolet
  (with-default-parameters (client environment global-environment)
    (iss #1=(macrolet ((foo (x) x)) (foo 234))
         (eval-expression client '#1# environment))))

(define-test macrolet-one-macro
  :parent macrolet
  (with-default-parameters (client environment global-environment)
    (iss #1=(macrolet ((foo (x) (list '1+ x))) (foo 234))
         (eval-expression client '#1# environment))))

(define-test macrolet-with-setf
  :parent macrolet
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((list (list 234)))
              (macrolet ((f () '(car list)))
                (setf (f) 345) list))
         (eval-expression client '#1# environment))))
