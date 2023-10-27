(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:progv-ast) continuation)
  (let ((symbols-temp (make-symbol "SYMBOLS"))
        (values-temp (make-symbol "VALUES"))
        (continuation-variable (gensym "C-")))
    `(let* ((,symbols-temp nil)
            (,values-temp nil)
            (,continuation-variable
              ,(cps-implicit-progn
                client
                (ico:form-asts ast)
                continuation))
            (,continuation-variable
              (lambda (&rest temp)
                (setq ,values-temp (car temp))
                (loop for symbol in ,symbols-temp
                      for value in ,values-temp
                      do (push (make-instance 'special-variable-entry
                                 :name symbol
                                 :value value)
                               *dynamic-environment*))
                ,continuation-variable))
            (,continuation-variable
              (lambda (&rest temp)
                (setq ,symbols-temp (car temp))
                ,(cps client
                      (ico:values-ast ast)
                      continuation-variable))))
       (cps client (ico:symbols-ast ast) continuation-variable))))
