(cl:in-package #:common-boot-test)

(define-test function)

(define-test function-with-simple-lambda-expression
  :parent function
  (with-default-parameters (client environment global-environment)
    (cbae:import-host-function client 'null global-environment)
    (cbae:import-host-function client 'error global-environment)
    (cbae:import-host-function client 'first global-environment)
    (cbae:import-host-function client 'rest global-environment)
    (cbae:import-host-function client '1+ global-environment)
    (cbae:import-host-function client 'funcall global-environment)
    (is #'equal
        (multiple-value-list
         #1=(funcall (function (lambda (x) (1+ x))) 234))
        (cbae:eval-expression '#1# environment))))
