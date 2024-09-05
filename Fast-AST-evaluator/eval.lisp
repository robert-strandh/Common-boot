(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod eval-cst (client cst environment)
  (let* ((ast (cb:cst-to-ast client cst environment))
         (builder (make-builder client environment))
         (top-level-function 
           (cm:with-builder builder
             (compile-ast client ast environment))))
    (funcall top-level-function)))

(defun ast-from-expression (expression environment)
  (let* ((cst (cst:cst-from-expression expression))
         (client (make-instance 'trucler-reference:client)))
    (cb:cst-to-ast client cst environment)))

(defun eval-expression (client expression environment)
  (eval-cst client
            (cst:cst-from-expression expression)
            environment))
