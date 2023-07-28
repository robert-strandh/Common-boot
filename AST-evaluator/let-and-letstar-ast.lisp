(cl:in-package #:common-boot-ast-evaluator)

(defun cps-let-let* (client ast environment continuation)
  ;; First enter all the lexical variables into the environment.
  (loop for binding-ast in (ico:binding-asts ast)
        for variable-name-ast = (ico:variable-name-ast binding-ast)
        do (when (typep variable-name-ast 'ico:variable-definition-ast)
             (setf (lookup variable-name-ast environment)
                   (make-symbol (symbol-name (ico:name variable-name-ast))))))
  ;; Next, compute the action of the body forms as an implicit PROGN.
  (let ((action (cps-implicit-progn
                 client (ico:form-asts ast) environment continuation)))
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
    action))
                        
(defmethod cps (client (ast ico:let-ast) environment continuation)
  (cps-let-let* client ast environment continuation))

(defmethod cps (client (ast ico:let*-ast) environment continuation)
  (cps-let-let* client ast environment continuation))
