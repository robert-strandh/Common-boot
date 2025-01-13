(cl:in-package #:common-boot-test)

(define-test symbol-macrolet)

(define-test symbol-macrolet-one-expansion
  :parent symbol-macrolet
  (with-default-parameters (client environment global-environment)
    (iss #1=(symbol-macrolet ((x (+ y 10))) (let ((y 20)) x))
         (eval-expression client '#1# environment))))

(define-test symbol-macrolet-two-expansions
  :parent symbol-macrolet
  (with-default-parameters (client environment global-environment)
    (iss #1=(symbol-macrolet ((x (+ y 10))
                              (z (+ x 5)))
              (let ((y 20)) z))
         (eval-expression client '#1# environment))))

(define-test symbol-macrolet-with-setf
  :parent symbol-macrolet
  (with-default-parameters (client environment global-environment)
    (iss #1=(let ((list (list 234)))
              (symbol-macrolet ((x (car list)))
                (setf x 345)))
         (eval-expression client '#1# environment))))
