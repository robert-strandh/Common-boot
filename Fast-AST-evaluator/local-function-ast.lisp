(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:local-function-ast))
  (let ((simplified-ast (simplify-ast ast)))
    (compile-local-function-ast client simplified-ast)))
