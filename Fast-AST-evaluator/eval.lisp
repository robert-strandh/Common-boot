(cl:in-package #:common-boot-fast-ast-evaluator)

(defgeneric translate-ast (client environment ast))

(defun translate (client ast environment)
  (let ((*host-names* (make-hash-table :test #'eq)))
    (translate-ast client environment ast)))

(defun simplify-ast (ast)
  (let* ((ast (iat:lexify-lambda-list ast))
         (ast (iat:split-let-or-let* ast))
         (ast (iat:replace-special-let-with-bind ast))
         (ast (iat:let-to-labels ast))
         (ast (iat:flet-to-labels ast)))
    ast))

(defun compile-ast (client ast environment)
  (let ((simplified-ast (simplify-ast ast)))
    (compile nil
             `(lambda ()
                (let ((dynamic-environment *dynamic-environment*))
                  (declare (ignorable dynamic-environment))
                  #+sbcl
                  (declare (sb-ext:muffle-conditions sb-ext:compiler-note))
                  ,(translate client simplified-ast environment))))))

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
