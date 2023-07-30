(cl:in-package #:common-boot-test)

(define-test application)

(define-test application-no-arguments
  (let* ((environment (cb:create-environment))
         (client (make-instance 'trucler-reference:client))
         (global-environment
           (trucler:global-environment client environment)))
    (cbae:import-host-function client '+ global-environment)
    (is #'equal
        (multiple-value-list (+))
        (cbae:eval-expression '(+) environment))))
