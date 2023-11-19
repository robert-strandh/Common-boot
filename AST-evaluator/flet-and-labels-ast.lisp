(cl:in-package #:common-boot-ast-evaluator)

(defun cps-function-ast
    (client lambda-list-ast form-asts continuation)
  (let ((lambda-list-variable-asts
          (common-boot::extract-variable-asts-in-lambda-list
           lambda-list-ast)))
    (loop for lambda-list-variable-ast in lambda-list-variable-asts
          do (setf (lookup lambda-list-variable-ast) (gensym))))
  (let* ((let*-ast (make-instance 'ico:let*-ast))
         (variable-name (make-symbol "ARGUMENTS"))
         (variable-ast
           (make-instance 'ico:variable-definition-ast :name variable-name))
         (temp (make-symbol "TEMP"))
         (continuation-variable (gensym "C-")))
    (cm:with-ast-origin lambda-list-ast
      (cm:destructure-lambda-list lambda-list-ast variable-ast let*-ast))
    (reinitialize-instance let*-ast
      :form-asts form-asts)
    (setf (lookup variable-ast) variable-name)
    `(step (list (xlambda (&rest ,variable-name)
                   ;; We need to wrap the argument list in LIST
                   ;; because of assignment conversion.  The argument
                   ;; list is going to be processed by
                   ;; VARIABLE-REFERENCE-ASTs and those assume that
                   ;; the variable is wrapped that way.
                   (let ((dynamic-environment
                           (prog1 *dynamic-environment*
                             (setf *dynamic-environment* nil))))
                     (declare (ignorable dynamic-environment))
                     (setq ,variable-name (list ,variable-name))
                     (let ((,continuation-variable
                             (lambda (&rest ,temp)
                               (declare (ignore ,temp))
                               ,(pop-stack-operation client))))
                       ,(cps client let*-ast continuation-variable)))))
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
