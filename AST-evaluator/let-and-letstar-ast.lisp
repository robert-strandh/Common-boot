(cl:in-package #:common-boot-ast-evaluator)

(defun cps-let-let* (client ast environment continuation)
  ;; First enter all the lexical variables into the environment.
  (loop for binding-ast in (ico:binding-asts ast)
        for variable-name-ast = (ico:variable-name-ast binding-ast)
        do (when (typep variable-name-ast 'ico:variable-definition-ast)
             (setf (lookup variable-name-ast environment)
                   (gensym))))
  ;; Next, compute the action of the body forms in reverse.
  (let ((form-asts (reverse (ico:form-asts ast))))
    (when (null form-asts)
      (setf form-asts
            (list (make-instance 'ico:literal-ast :literal nil)))
      (let ((action (cps client (first form-asts) environment continuation)))
        (loop for form-ast in (rest form-asts)
              for argument-variable = (gensym)
              do (setf action
                       (cps client
                            form-ast
                            environment
                            `(lambda (&rest ,argument-variable)
                               (declare (ignore argument-variable))
                               ,action))))
        (loop for binding-ast in (reverse (ico:binding-asts ast))
              for variable-name-ast = (ico:variable-name-ast binding-ast)
              for variable-name = (lookup variable-name-ast environment)
              for form-ast = (ico:form-ast binding-ast)
              do (setf action
                       (cps client
                            form-ast
                            environment
                            `(lambda (&rest ,variable-name)
                               (setf ,variable-name
                                     (car ,variable-name))
                               ,action))))
        action))))
                        
(defmethod cps (client (ast ico:let-ast) environment continuation)
  (cps-let-let* client ast environment continuation))

(defmethod cps (client (ast ico:let*-ast) environment continuation)
  (cps-let-let* client ast environment continuation))
