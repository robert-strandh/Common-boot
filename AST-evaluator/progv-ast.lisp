(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:progv-ast) environment continuation)
  (let ((symbols-temp (make-symbol "SYMBOLS"))
        (values-temp (make-symbol "VALUES"))
        (ignore-temp (make-symbol "IGNORE")))
    (cps client
         (ico:symbols-ast ast)
         environment
         `(lambda (&rest ,symbols-temp)
            (setq ,symbols-temp (car ,symbols-temp))
            ,(cps client
                  (ico:values-ast ast)
                  environment
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
                       environment
                       `(lambda (&rest ,ignore-temp)
                          (declare (ignore ,ignore-temp))
                          (setq *continuation*
                                ,continuation)))))))))
