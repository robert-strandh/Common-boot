(cl:in-package #:common-boot-ast-evaluator)

;;; FIXME: rewrite so that CPS is always passed a variable (i.e., a
;;; symbol) as the CONTINUATION argument.

(defmethod cps (client (ast ico:progv-ast) continuation)
  (let ((symbols-temp (make-symbol "SYMBOLS"))
        (values-temp (make-symbol "VALUES")))
    (cps client
         (ico:symbols-ast ast)
         `(lambda (&rest ,symbols-temp)
            (setq ,symbols-temp (car ,symbols-temp))
            ,(cps client
                  (ico:values-ast ast)
                  `(lambda (&rest ,values-temp)
                     (setq ,values-temp (car ,values-temp))
                     (loop for symbol in ,symbols-temp
                           for value in ,values-temp
                           do (push (make-instance 'special-variable-entry
                                      :name symbol
                                      :value value)
                                    *dynamic-environment*))
                     ,(cps-implicit-progn
                       client
                       (ico:form-asts ast)
                       continuation)))))))
