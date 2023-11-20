(cl:in-package #:common-boot-ast-evaluator)

(defun cps-function-ast
    (client lambda-list-ast form-asts continuation)
  (let ((lambda-list-variable-asts
          (iat:extract-variable-asts-in-lambda-list
           lambda-list-ast)))
    (loop for lambda-list-variable-ast in lambda-list-variable-asts
          do (setf (lookup lambda-list-variable-ast) (gensym)))
    (let* ((host-lambda-list
             (host-lambda-list-from-lambda-list-ast lambda-list-ast))
           (temp (make-symbol "TEMP"))
           (continuation-variable (gensym "C-")))
      `(step (list (xlambda ,host-lambda-list
                     ;; We need to wrap each lambda-list variable in
                     ;; LIST because of assignment conversion.
                     (setq ,@(loop for lambda-list-variable-ast
                                     in lambda-list-variable-asts
                                   for name = (lookup lambda-list-variable-ast)
                                   collect name
                                   collect `(list ,name)))
                     (let ((dynamic-environment
                             (prog1 *dynamic-environment*
                               (setf *dynamic-environment* nil))))
                       (declare (ignorable dynamic-environment))
                       (let ((,continuation-variable
                               (lambda (&rest ,temp)
                                 (declare (ignore ,temp))
                                 ,(pop-stack-operation client))))
                         ,(cps-implicit-progn
                           client form-asts continuation-variable)))))
             ,continuation))))

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
