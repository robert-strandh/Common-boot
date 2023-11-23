(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client environment (ast ico:multiple-value-prog1-ast) continuation)
  (let ((continuation-variable (gensym "C-"))
        (values-variable (gensym "V-")))
    `(let* ((,values-variable nil)
            (,continuation-variable
              (lambda (&rest ignore)
                (declare (ignore ignore))
                (step ,values-variable ,continuation)))
            (,continuation-variable
              (lambda (&rest values)
                (setq ,values-variable values)
                ,(cps-implicit-progn
                  client environment
                  (ico:form-asts ast)
                  continuation-variable))))
       ,(cps client environment (ico:values-ast ast) continuation-variable))))
