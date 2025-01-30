(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:progv-ast))
  (let ((symbols-ast (ico:symbols-ast ast))
        (values-ast (ico:values-ast ast))
        (symbols-var (gensym))
        (values-var (gensym)))
    `(let ((dynamic-environment dynamic-environment))
       (declare (ignorable dynamic-environment))
       (let ((,symbols-var ,(translate-ast client symbols-ast))
             (,values-var ,(translate-ast client values-ast)))
         (loop for symbol in ,symbols-var
               for value in ,values-var
               do (push (make-instance 'special-variable-entry
                          :name symbol
                          :value value)
                        dynamic-environment))
         (when (< (length ,values-var) (length ,symbols-var))
           (loop with count = (length ,values-var)
                 with symbols = (subseq ,symbols-var count)
                 for symbol in symbols
                 do (push (make-instance 'special-variable-entry
                            :name symbol)
                          dynamic-environment)))
         ,@(translate-implicit-progn
            client (ico:form-asts ast))))))
