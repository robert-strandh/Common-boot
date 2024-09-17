(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:progv-ast))
  (let ((symbols (interpret-ast client environment (ico:symbols-ast ast)))
        (values (interpret-ast client environment (ico:values-ast ast))))
    (let ((*dynamic-environment* *dynamic-environment*))
      (loop for symbol in symbols
            for value in values
            do (push (make-instance 'special-variable-entry
                       :name symbol
                       :value value)
                     *dynamic-environment*))
      (when (< (length values) (length symbols))
        (loop with count = (length values)
              with symbols = (subseq symbols count)
              for symbol in symbols
              do (push (make-instance 'special-variable-entry
                         :name symbol)
                       *dynamic-environment*)))
      (interpret-implicit-progn-asts
       client environment (ico:form-asts ast)))))
