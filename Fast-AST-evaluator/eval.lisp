(cl:in-package #:common-boot-fast-ast-evaluator)

(defgeneric translate-ast (client environment ast))

(defun translate (client ast environment)
  (let ((*host-names* (make-hash-table :test #'eq)))
    (translate-ast client environment ast)))

(defun compile-ast (client ast environment)
  (compile nil
           `(lambda ()
              (let ((dynamic-environment *dynamic-environment*))
                (declare (ignorable dynamic-environment))
                ,(translate client ast environment)))))

(defmethod eval-cst (client cst environment)
  (let* ((ast (cb:cst-to-ast client cst environment))
         (builder (cb::make-builder client environment))
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
