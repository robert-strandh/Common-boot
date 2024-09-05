(cl:in-package #:common-boot-fast-ast-evaluator)

;;; This method is almost certainly wrong.
(defmethod translate-ast
    (client environment (ast ico:function-reference-ast))
  `(function ,(ico:name ast)))

(defmethod translate-ast
    (client environment (ast ico:global-function-name-reference-ast))
  (let ((name (ico:name (ico:name-ast ast))))
    `(car ,(clostrum:ensure-operator-cell client environment name))))
