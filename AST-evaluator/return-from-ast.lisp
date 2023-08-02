(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:return-from-ast) environment continuation)
  (let* ((form-ast (ico:form-ast ast))
         (block-name-ast (ico:name-ast ast))
         (name (lookup (ico:block-name-definition-ast block-name-ast)
                       environment))
         (temp (gensym)))
    (cps client
         (if (null form-ast)
             (make-instance 'ico:literal-ast :literal nil)
             form-ast)
         environment
         `(lambda (&rest ,temp)
            (loop for entry in *dynamic-environment*
                  do (when (and (typep entry 'block-entry)
                                (eq ',name (name entry)))
                       ;; FIXME: check for expired entry.
                       (step ,temp
                             (continuation entry))))))))
