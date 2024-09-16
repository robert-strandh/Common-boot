(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast
    (client environment (ast ico:global-function-name-reference-ast))
  (let ((name (ico:name ast))
        (environment
          (trucler:global-environment client *global-environment*)))
    (car (clostrum:ensure-operator-cell client environment name))))
