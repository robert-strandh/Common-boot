(cl:in-package #:common-boot-fast-ast-evaluator)

;;; This method is almost certainly wrong.
(defmethod translate-ast
    (client environment (ast ico:function-reference-ast))
  (let ((function-definition-ast
          (ico:local-function-name-definition-ast ast)))
    `(function ,(lookup function-definition-ast))))

(defmethod translate-ast
    (client environment (ast ico:global-function-name-reference-ast))
  (let ((name (ico:name ast))
        (env (trucler:global-environment client environment)))
    `(car ',(clostrum:ensure-operator-cell client env name))))
