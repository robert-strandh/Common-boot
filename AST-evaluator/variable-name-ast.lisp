(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps
    (client environment (ast ico:variable-reference-ast) continuation)
  (let ((definition-ast (ico:variable-definition-ast ast)))
    `(step
      ;; The LIST is so that we the STEP can use APPLY to apply the
      ;; continuation to the list of arguments, and the CAR is because
      ;; of assignment conversion, whereby every host variable
      ;; representing a target variable contains a CONS cell where the
      ;; target variable is the CAR of that CONS cell.
      (list (car ,(lookup definition-ast)))
      ,continuation)))

(defmethod cps
    (client environment (ast ico:special-variable-reference-ast) continuation)
  `(step (list (symbol-value
                client
                ',(ico:name ast)
                (clostrum-sys:variable-cell
                 client environment ',(ico:name ast))
                dynamic-environment))
         ,continuation))
