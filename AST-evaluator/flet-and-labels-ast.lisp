(cl:in-package #:common-boot-ast-evaluator)

(defun cps-function-ast
    (client lambda-list-ast form-asts environment continuation)
  (let ((let*-ast (make-instance 'ico:let*-ast))
        (variable-ast (make-symbol "ARGUMENTS"))
        (temp-ast (make-symbol "TEMP")))
    (cm:with-ast-origin lambda-list-ast
      (cm:with-builder
        (cm:destructure-lambda-list lambda-list-ast variable-ast let*-ast)))
    (reinitialize-instance let*-ast
      :form-asts form-asts)
    `(step (lambda (&rest ,variable-ast)
             ,(cps client
                   let*-ast
                   environment
                   `(lambda (&rest ,temp-ast)
                      ,(pop-stack-operation client))))
           ,continuation)))

(defun cps-flet-and-labels (client ast environment continuation)
  ;; First enter all the local-function-names into the environment.
  (loop for binding-ast in (ico:binding-asts ast)
        for variable-name-ast = (ico:variable-name-ast binding-ast)
        do (setf (lookup variable-name-ast environment)
                 (make-symbol (symbol-name (ico:name variable-name-ast)))))
  ;; Next, compute the action of the body forms as an implicit PROGN.
  (let ((action (cps-implicit-progn
                 client (ico:form-asts ast) environment continuation)))
    ;; Finally compute-the actions of the binding forms.
    (loop for binding-ast in (reverse (ico:binding-asts ast))
          for function-name-ast = (ico:variable-name-ast binding-ast)
          for function-name = (lookup function-name-ast environment)
          for local-function-ast = (ico:form-ast ast)
          for lambda-list-ast = (ico:lambda-list-ast local-function-ast)
          for form-asts = (ico:form-asts local-function-ast)
          do (setf action
                   (cps-function-ast
                    client
                    lambda-list-ast
                    form-asts
                    environment
                    `(lambda (&rest ,function-name)
                       (setf ,function-name
                             (car ,function-name))
                       ,action))))
    action))

(defmethod cps (client (ast ico:flet-ast) environment continuation)
  (cps-flet-and-labels client ast environment continuation))

(defmethod cps (client (ast ico:labels-ast) environment continuation)
  (cps-flet-and-labels client ast environment continuation))
