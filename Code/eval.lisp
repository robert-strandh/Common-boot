(cl:in-package #:common-boot)

(defmethod eval-cst (client cst environment)
  (let* ((ast (cst-to-ast client cst environment))
         (builder (make-builder client environment)))
    (cm:with-builder builder
      (cbae:eval-ast client ast environment))))

(defun cps-from-expression (expression environment)
  (let* ((cst (cst:cst-from-expression expression))
         (client (make-instance 'trucler-reference:client))
         (ast (cst-to-ast client cst environment))
         (builder (make-builder client environment)))
    (cm:with-builder builder
      (cbae:ast-to-cps client ast environment))))

(defun ast-from-expression (expression environment)
  (let* ((cst (cst:cst-from-expression expression))
         (client (make-instance 'trucler-reference:client)))
    (cst-to-ast client cst environment)))

(defun eval-expression (client expression environment)
  (apply #'values
         (eval-cst client
                   (cst:cst-from-expression expression)
                   environment)))
