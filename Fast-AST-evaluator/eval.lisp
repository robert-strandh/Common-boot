(cl:in-package #:common-boot-fast-ast-evaluator)

(defgeneric translate-ast (client ast))

(defun tree-size (tree)
  (let ((ht (make-hash-table :test #'eq)))
    (labels ((aux (tree)
               (if (or (atom tree) (gethash tree ht))
                   0
                   (progn 
                     (setf (gethash tree ht) t)
                     (+ 1 (aux (car tree)) (aux (cdr tree)))))))
      (aux tree))))

(defun translate (client ast)
  (let* ((*host-names* (make-hash-table :test #'eq))
         (result (translate-ast client ast)))
    result))

(defun simplify-ast (ast)
  (let* ((ast (iat:macrolet-to-locally ast))
         (ast (iat:lexify-lambda-list ast))
         (ast (iat:split-let-or-let* ast))
         (ast (iat:replace-special-let-with-bind ast))
         (ast (iat:let-to-labels ast))
         (ast (iat:flet-to-labels ast))
         (ast (iat:split-setq ast))
         (ast (iat:inline-inlinable-functions ast))
         (ast (iat:remove-degenerate-labels ast))
         (ast (iat:assignment-conversion ast))
         (ast (iat:convert-block ast))
         (ast (iat:remove-unused-blocks ast))
         (ast (iat:convert-tagbody ast))
         (ast (iat:transform-function-definition-and-reference ast))
         (ast (iat:eliminate-function ast))
         (ast (iat:closure-conversion ast)))
    ast))

(defvar *code-object-names*)

(defgeneric compile-local-function-ast (client ast))

(defmethod compile-local-function-ast (client ast)
  (let* ((lambda-list-ast (ico:lambda-list-ast ast))
         (lambda-list-variable-asts
           (iat:extract-variable-asts-in-lambda-list lambda-list-ast))
         (lambda-list-variables
           (loop for lambda-list-variable-ast in lambda-list-variable-asts
                 collect (gensym))))
    (loop for lambda-list-variable-ast in lambda-list-variable-asts
          for lambda-list-variable in lambda-list-variables
          do (setf (lookup lambda-list-variable-ast) lambda-list-variable))
    (let ((host-lambda-list
            (host-lambda-list-from-lambda-list-ast lambda-list-ast)))
      (compile nil
               `(lambda ,host-lambda-list
                  (declare (ignorable ,@lambda-list-variables))
                  (let ((dynamic-environment *dynamic-environment*))
                    (declare (ignorable dynamic-environment))
                    ,@(translate-implicit-progn
                       client (ico:form-asts ast))))))))

(defvar *global-environment*)

(defun compile-ast (client ast environment)
  (let* ((simplified-ast (simplify-ast ast))
         (*global-environment* (trucler:global-environment client environment))
         (*code-object-names* (make-hash-table :test #'eq))
         (local-function-asts (find-local-function-asts ast))
         (names (loop for local-function-ast in local-function-asts
                      for name-ast = (ico:name-ast local-function-ast)
                      for name = (gensym)
                      do (setf (gethash name-ast *code-object-names*)
                               name)
                      collect name))
         (code-objects
           (loop for local-function-ast in local-function-asts
                 collect (compile-local-function-ast
                          client local-function-ast))))
    (compile
     nil
     `(lambda ()
        (let ((dynamic-environment *dynamic-environment*))
          (declare (ignorable dynamic-environment))
          #+sbcl
          (declare (sb-ext:muffle-conditions sb-ext:compiler-note))
          ,(translate client simplified-ast))))))

(defmethod cb:eval-cst ((client client) cst environment)
  (let* ((ast (cb:cst-to-ast client cst environment))
         (builder (cb:make-builder client environment))
         (global-environment (trucler:global-environment client environment))
         (top-level-function 
           (cm:with-builder builder
             (compile-ast client ast global-environment))))
    (funcall top-level-function)))

(defmethod cb:compile-local-macro-function-ast (client ast environment)
  (let ((simplified-ast (simplify-ast ast))
        (*global-environment* environment))
    (compile
     nil
     `(lambda ()
        (let ((dynamic-environment *dynamic-environment*))
          (declare (ignorable dynamic-environment))
          #+sbcl
          (declare (sb-ext:muffle-conditions sb-ext:compiler-note))
          ,(cons 'lambda
                 (cdr (translate client simplified-ast))))))))
