(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client environment (ast ico:return-from-ast) continuation)
  (let* ((form-ast (ico:form-ast ast))
         (block-name-ast (ico:name-ast ast))
         (name (lookup (ico:block-name-definition-ast block-name-ast)))
         (continuation-variable (gensym "C-"))
         (temp (gensym)))
    `(let ((,continuation-variable
             (make-before-continuation
              (lambda (&rest ,temp)
                (setf arguments ,temp)
                (let ((entry (do-return-from ',name dynamic-environment)))
                  (setf continuation (continuation entry))
                  (throw (catch-tag entry) nil)))
              :origin ',(ico:origin ast)
              :next ,continuation)))
       ,(cps client environment
             (if (null form-ast)
                 (make-instance 'ico:literal-ast :literal nil)
                 form-ast)
             continuation-variable))))
