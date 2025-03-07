(cl:in-package #:common-boot-hir-evaluator-test)

(define-test special-variable)

(define-test special-variable-1
  :parent special-variable
  (with-default-parameters (client environment global-environment)
    (iss #1=(flet ((f () (declare (special *foo*)) *foo*))
              (flet ((g ()
                       (let ((*foo* 234))
                         (declare (special *foo*))
                         (f))))
                (g)))
         (eval-expression client '#1# environment))))

(define-test special-variable-2
  :parent special-variable
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((*foo* (let ((x 10)) x)))
              (declare (special *foo*))
              *foo*)
         (eval-expression client '#1# environment))))

(define-test special-variable-3
  :parent special-variable
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((*print-base* *print-base*)) nil)
         (eval-expression client '#1# environment))))
