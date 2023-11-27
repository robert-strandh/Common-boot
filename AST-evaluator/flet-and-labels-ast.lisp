(cl:in-package #:common-boot-ast-evaluator)

(defun cps-function-ast
    (client environment lambda-list-ast form-asts continuation)
  (let ((lambda-list-variable-asts
          (iat:extract-variable-asts-in-lambda-list
           lambda-list-ast)))
    (loop for lambda-list-variable-ast in lambda-list-variable-asts
          do (setf (lookup lambda-list-variable-ast) (gensym)))
    (let* ((host-lambda-list
             (host-lambda-list-from-lambda-list-ast lambda-list-ast))
           (temp (make-symbol "TEMP"))
           (block-variable (gensym))
           (exit (gensym "C-")))
      `(step (list (xlambda ,host-lambda-list
                     (block ,block-variable
                       ;; We need to wrap each lambda-list variable in
                       ;; LIST because of assignment conversion.
                       (setq ,@(loop for lambda-list-variable-ast
                                       in lambda-list-variable-asts
                                     for name = (lookup lambda-list-variable-ast)
                                     collect name
                                     collect `(list ,name)))
                       (let ((;; The dynamic environment is
                              ;; transmitted across function calls in
                              ;; the host special variable
                              ;; *DYNAMIC-ENVIRONMENT*.  The host
                              ;; variable DYNAMIC-ENVIRONMENT is
                              ;; referred to by CPS-translated code
                              ;; for access to the target dynamic
                              ;; environment.
                              dynamic-environment
                               (prog1 *dynamic-environment*
                                 (setf *dynamic-environment* nil)))
                             (;; The CPS translation of FORM* is done
                              ;; in this continuation.  So when the
                              ;; evaluation of FORM* finishes
                              ;; normally, the values produced are
                              ;; passed to this continuation resulting
                              ;; in a return from this function.
                              ,exit
                               (make-before-continuation
                                (lambda (&rest ,temp)
                                  (return-from ,block-variable
                                    (apply #'values ,temp)))))
                             ;; The function-wide variable used by
                             ;; CPS-translated code to hold the
                             ;; current continuation.  We dont
                             ;; initialize it, because what it is
                             ;; initialized to contains references to
                             ;; it, so we use SETF leter on instead.
                             continuation
                             ;; The function-wide variable used by
                             ;; CPS-translated code to hold arguments
                             ;; to transmit to CONTINUATION.
                             arguments)
                         (declare (ignorable dynamic-environment))
                         (step '()
                               (make-before-continuation
                                (lambda ()
                                  ,(cps-implicit-progn
                                    client environment form-asts exit))
                                :next ,exit))
                         (trampoline-loop)))))
             ,continuation))))

(defun cps-flet-and-labels (client environment ast continuation)
  ;; First enter all the local-function-names into the host mapping.
  (loop for binding-ast in (ico:binding-asts ast)
        for name-ast = (ico:name-ast binding-ast)
        do (setf (lookup name-ast)
                 (make-symbol (symbol-name (ico:name name-ast)))))
  ;; Next, compute the action of the body forms as an implicit PROGN.
  (let ((action (cps-implicit-progn
                 client environment (ico:form-asts ast) continuation)))
    ;; Finally compute-the actions of the binding forms.
    (loop for local-function-ast in (reverse (ico:binding-asts ast))
          for function-name-ast = (ico:name-ast local-function-ast)
          for function-name = (lookup function-name-ast)
          for lambda-list-ast = (ico:lambda-list-ast local-function-ast)
          for form-asts = (ico:form-asts local-function-ast)
          do (setf action
                   (cps-function-ast
                    client environment
                    lambda-list-ast
                    form-asts
                    `(make-before-continuation
                      (lambda (&rest ,function-name)
                        (setf ,function-name
                              (car ,function-name))
                        ,action)
                      :origin ',(ico:origin function-name-ast)))))
    action))

(defmethod cps (client environment (ast ico:flet-ast) continuation)
  (cps-flet-and-labels client environment ast continuation))

(defmethod cps (client environment (ast ico:labels-ast) continuation)
  (cps-flet-and-labels client environment ast continuation))
