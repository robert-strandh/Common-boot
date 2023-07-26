(cl:in-package #:common-boot-ast-evaluator)

(defun cps-implicit-progn (client form-asts environment continuation)
  (let ((asts (reverse form-asts)))
    (when (null asts)
      (setf asts
            (list (make-instance 'ico:literal-ast :literal nil)))
      (let ((action (cps client (first asts) environment continuation)))
        (loop for form-ast in (rest asts)
              for argument-variable = (gensym)
              do (setf action
                       (cps client
                            form-ast
                            environment
                            `(lambda (&rest ,argument-variable)
                               (declare (ignore argument-variable))
                               ,action))))
        action))))

(defmethod cps (client (ast ico:progn-ast) environment continuation)
  (cps-implicit-progn client (ico:form-asts ast) environment continuation))
