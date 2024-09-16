(cl:in-package #:common-boot-ast-interpreter)

(defun handle-required-parameters
    (section-ast remaining-arguments environment)
  (unless (null section-ast)
    (loop for parameter-ast in (ico:parameter-asts section-ast)
          do (if (null remaining-arguments)
                 (error "Not enough arguments")
                 (push (cons parameter-ast
                             (pop remaining-arguments))
                       environment))))
  (values remaining-arguments environment))

(defun handle-optional-parameters
    (section-ast remaining-arguments environment)
  (unless (null section-ast)
    (loop for optional-parameter-ast in (ico:parameter-asts section-ast)
          for supplied-p-parameter-ast
            = (ico:supplied-p-parameter-ast optional-parameter-ast)
          for parameter-ast = (ico:parameter-ast optional-parameter-ast)
          do (if (null remaining-arguments)
                 (progn (push (cons parameter-ast nil)
                              environment)
                        (push (cons supplied-p-parameter-ast nil)
                              environment))
                 (progn (push (cons parameter-ast
                                    (pop remaining-arguments))
                              environment)
                        (push (cons supplied-p-parameter-ast t)
                              environment)))))
  (values remaining-arguments environment))

;;; Return the value of the first keyword argument with
;;; :ALLOW-OTHER-KEYS, or NIL if :ALLOW-OTHER-KEYS is not supplied.
(defun allow-other-keys-true-supplied-p (remaining-arguments)
  (loop for (key value) on remaining-arguments by #'cddr
        when (eq key :allow-other-keys)
          return value
        finally (return nil)))

;;; Return a list of the keywords mentioned in the key section of the
;;; lambda list.
(defun mentioned-keywords (key-section-ast)
  (loop for key-parameter-ast in (ico:parameter-asts key-section-ast)
        for keyword-ast = (ico:keyword-ast key-parameter-ast)
        collect (ico:name keyword-ast)))

;;; Return T if any keyword argument is allowed, or a list of the
;;; keywords allowed to be supplied.
(defun compute-allowed-keywords (key-section-ast remaining-arguments)
  (if (or (not (null (ico:allow-other-keys-ast key-section-ast)))
          (allow-other-keys-true-supplied-p remaining-arguments))
      t
      (cons ':allow-other-keys (mentioned-keywords key-section-ast))))

(defun handle-key-parameter
    (key-parameter-ast remaining-arguments environment allowed-keys)
  (let* ((supplied-p-parameter-ast
           (ico:supplied-p-parameter-ast key-parameter-ast))
         (parameter-ast (ico:parameter-ast key-parameter-ast))
         (keyword-ast (ico:lambda-list-keyword-ast key-parameter-ast))
         (keyword (ico:name keyword-ast)))
    (when (and (listp allowed-keys)
               (not (member keyword allowed-keys)))
      (error "Invalid key: ~s" keyword))
    (loop for (key value) on remaining-arguments by #'cddr
          when (eq key keyword)
            return (acons parameter-ast value
                          (acons supplied-p-parameter-ast t
                                 environment))
          finally (return (acons parameter-ast nil
                                 (acons supplied-p-parameter-ast nil
                                        environment))))))

(defun handle-key-parameters (section-ast remaining-arguments environment)
  (let ((allowed-keys
          (compute-allowed-keywords section-ast remaining-arguments)))
    (loop for key-parameter-ast in (ico:parameter-asts section-ast)
          do (setq environment
                   (handle-key-parameter
                    key-parameter-ast
                    remaining-arguments
                    environment
                    allowed-keys)))))

(defun interpret-local-function-ast-components
    (client environment lambda-list-ast form-asts)
  (lambda (&rest arguments)
    (let ((new-environment environment)
          (remaining-arguments arguments)
          (required-section-ast (ico:required-section-ast lambda-list-ast))
          (optional-section-ast (ico:optional-section-ast lambda-list-ast))
          (rest-section-ast (ico:rest-section-ast lambda-list-ast))
          (key-section-ast (ico:key-section-ast lambda-list-ast)))
      (multiple-value-setq (remaining-arguments new-environment)
        (handle-required-parameters
         required-section-ast remaining-arguments new-environment))
      (multiple-value-setq (remaining-arguments new-environment)
        (handle-optional-parameters
         optional-section-ast remaining-arguments new-environment))
      (unless (null rest-section-ast)
        (push (cons (ico:parameter-ast rest-section-ast) remaining-arguments)
              new-environment))
      (unless (null key-section-ast)
        (assert (evenp (length remaining-arguments)))
        (multiple-value-setq (remaining-arguments new-environment)
          (handle-key-parameters
           key-section-ast remaining-arguments new-environment)))
      (interpret-implicit-progn-asts client environment form-asts))))
    
(defmethod interpret-ast (client environment (ast ico:labels-ast))
  (let ((new-environment environment))
    ;; First augment the environment temporarily with NILs.
    (loop for local-function-ast in (ico:binding-asts ast)
          for name-ast = (ico:name-ast local-function-ast)
          do (push (cons name-ast nil) new-environment))
    ;; Then compute the local functions using the augmented
    ;; environment.
    (loop for binding-ast in (ico:binding-asts ast)
          for name-ast = (ico:name-ast binding-ast)
          for lambda-list-ast = (ico:lambda-list-ast binding-ast)
          for form-asts = (ico:form-asts binding-ast)
          for function
            = (interpret-local-function-ast-components
               client new-environment lambda-list-ast form-asts)
          do (setf (cdr (assoc name-ast new-environment)) function))
    ;; Finally interpret the body of the LABELS-AST in the new
    ;; environment.
    (interpret-implicit-progn-asts
     client new-environment (ico:form-asts ast))))
