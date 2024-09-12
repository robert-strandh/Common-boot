(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast
    (client environment (ast ico:function-reference-ast))
  (let ((function-definition-ast
          (ico:local-function-name-definition-ast ast)))
    `(function ,(lookup function-definition-ast))))

(defmethod translate-ast
    (client environment (ast ico:global-function-name-reference-ast))
  (let ((name (ico:name ast))
        (env (trucler:global-environment client environment)))
    `(car (load-time-value
           ',(clostrum:ensure-operator-cell client env name) nil))))

;;; This code used to read:
;;; `(car ',(clostrum:ensure-operator-cell client env name))
;;; but then at least one compiler optimizes it so that the call to
;;; CAR is removed.  As a result, if the function of the cell is
;;; undefined at compile time, we always get the function that signals
;;; an UNDEFINED-FUNCTION error.
