(cl:in-package #:common-boot-fast-ast-evaluator)

(defgeneric translate-ast (client environment ast))

(defun tree-size (tree)
  (let ((ht (make-hash-table :test #'eq)))
    (labels ((aux (tree)
               (if (or (atom tree) (gethash tree ht))
                   0
                   (progn 
                     (setf (gethash tree ht) t)
                     (+ 1 (aux (car tree)) (aux (cdr tree)))))))
      (aux tree))))

(defun translate (client ast environment)
  (let* ((*host-names* (make-hash-table :test #'eq))
         (result (translate-ast client environment ast)))
    result))

(defun simplify-ast (ast)
  (let* ((ast (iat:lexify-lambda-list ast))
         (ast (iat:split-let-or-let* ast))
         (ast (iat:replace-special-let-with-bind ast))
         (ast (iat:let-to-labels ast))
         (ast (iat:flet-to-labels ast)))
    ast))

(defun compile-ast (client ast environment)
  (let ((simplified-ast (simplify-ast ast)))
    (compile
     nil
     `(lambda ()
        (let ((dynamic-environment *dynamic-environment*))
          (declare (ignorable dynamic-environment))
          #+sbcl
          (declare (sb-ext:muffle-conditions sb-ext:compiler-note))
          ,(translate client simplified-ast environment))))))

(defun compile-local-macro-function-ast (client ast environment)
  (let ((simplified-ast (simplify-ast ast)))
    (compile
     nil
     `(lambda ()
        (let ((dynamic-environment *dynamic-environment*))
          (declare (ignorable dynamic-environment))
          #+sbcl
          (declare (sb-ext:muffle-conditions sb-ext:compiler-note))
          ,(cons 'lambda
                 (cdr (translate client simplified-ast environment))))))))
