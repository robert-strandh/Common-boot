(cl:in-package #:common-boot-ast-evaluator)

(defun cps-function-ast
    (client lambda-list-ast form-asts continuation)
  (let ((let*-ast (make-instance 'ico:let*-ast))
        (variable-ast (make-symbol "ARGUMENTS"))
        (temp (make-symbol "TEMP")))
    (cm:with-ast-origin lambda-list-ast
      (cm:destructure-lambda-list lambda-list-ast variable-ast let*-ast))
    (reinitialize-instance let*-ast
      :form-asts form-asts)
    `(step (lambda (&rest ,variable-ast)
             ,(cps client
                   let*-ast
                   `(lambda (&rest ,temp)
                      ,(pop-stack-operation client))))
           ,continuation)))

(defun cps-flet-and-labels (client ast continuation)
  ;; First enter all the local-function-names into the host mapping.
  (loop for binding-ast in (ico:binding-asts ast)
        for name-ast = (ico:name-ast binding-ast)
        do (setf (lookup name-ast)
                 (make-symbol (symbol-name (ico:name name-ast)))))
  ;; Next, compute the action of the body forms as an implicit PROGN.
  (let ((action (cps-implicit-progn
                 client (ico:form-asts ast) continuation)))
    ;; Finally compute-the actions of the binding forms.
    (loop for local-function-ast in (reverse (ico:binding-asts ast))
          for function-name-ast = (ico:name-ast local-function-ast)
          for function-name = (lookup function-name-ast)
          for lambda-list-ast = (ico:lambda-list-ast local-function-ast)
          for form-asts = (ico:form-asts local-function-ast)
          do (setf action
                   (cps-function-ast
                    client
                    lambda-list-ast
                    form-asts
                    `(lambda (&rest ,function-name)
                       (setf ,function-name
                             (car ,function-name))
                       ,action))))
    action))

(defmethod cps (client (ast ico:flet-ast) continuation)
  (cps-flet-and-labels client ast continuation))

(defmethod cps (client (ast ico:labels-ast) continuation)
  (cps-flet-and-labels client ast continuation))
