(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:return-from-ast) continuation)
  (let* ((form-ast (ico:form-ast ast))
         (block-name-ast (ico:name-ast ast))
         (name (lookup (ico:block-name-definition-ast block-name-ast)))
         (temp (gensym)))
    (cps client
         (if (null form-ast)
             (make-instance 'ico:literal-ast :literal nil)
             form-ast)
         `(lambda (&rest ,temp)
            (declare (ignore ,temp))
            (do-return-from ',name)))))
