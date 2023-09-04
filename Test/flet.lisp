(cl:in-package #:common-boot-test)

(define-test flet)

(define-test flet-no-parameters
  :parent flet
  (with-default-parameters (client environment global-environment)
    (iss #1=(flet ((f () 234)) (f))
         (eval-expression '#1# environment))))

(define-test flet-one-parameter
  :parent flet
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client 'null global-environment)
    (cbae:import-host-function client 'error global-environment)
    (cbae:import-host-function client 'first global-environment)
    (cbae:import-host-function client 'rest global-environment)
    (iss #1=(flet ((f (x) x)) (f 234))
         (eval-expression '#1# environment))))

(define-test flet-nested
  :parent flet
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client 'null global-environment)
    (cbae:import-host-function client 'error global-environment)
    (cbae:import-host-function client 'first global-environment)
    (cbae:import-host-function client 'rest global-environment)
    (cbae:import-host-function client '+ global-environment)
    (iss #1=(flet ((f (x) (+ x 1)))
              (flet ((f (x) x)
                     (g (x) (f x)))
                (g 234)))
         (eval-expression '#1# environment))))
