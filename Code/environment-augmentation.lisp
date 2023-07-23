(cl:in-package #:common-boot)

(defgeneric maybe-augment-environment-with-special-ast
    (client declaration-specifier-ast environment))

;;; This case is a bit tricky, because if the variable is globally
;;; special, nothing should be added to the environment.
(defmethod maybe-augment-environment-with-special-ast
    (client declaration-specifier-ast environment)
  (let ((new-environment environment))
    (loop for name-ast in (ico:name-asts declaration-specifier-ast)
          for name = (ico:name name-ast)
          for description
            = (trucler:describe-variable client environment name)
          unless (typep description
                        'trucler:global-special-variable-description)
            do (setf new-environment
                     (trucler:add-local-special-variable
                      client new-environment name)))
    new-environment))

(defmethod augment-environment-with-declaration
    (client
     (declaration-identifier (eql 'special))
     declaration-identifier-cst
     declaration-data-cst
     environment)
  ;; This case is a bit tricky, because if the
  ;; variable is globally special, nothing should
  ;; be added to the environment.
  (let ((info (trucler:describe-variable
               client environment (cst:raw (cst:first declaration-data-cst)))))
    (if (typep info 'trucler:global-special-variable-description)
        environment
        (trucler:add-local-special-variable
         client environment (cst:raw (cst:first declaration-data-cst))))))

;;; Given a single VARIABLE-NAME-AST bound by some binding form, a
;;; list of DECLARATION-SPECIFIER-ASTs,, and an environment in which
;;; the binding form is compiled, return true if and only if the
;;; variable to be bound is special.  Return a second value indicating
;;; whether the variable is globally special.
(defun variable-is-special-p
    (client variable-name-ast declaration-specifier-asts environment)
  (let* ((name (ico:name variable-name-ast))
         (existing-description
           (trucler:describe-variable client environment name))
         (already-globally-special-p
           (typep existing-description
                  'trucler:global-special-variable-description))
         (declared-special-p
           (loop for declaration-specifier-ast in declaration-specifier-asts
                   thereis (and (typep declaration-specifier-ast
                                       'ico:special-ast)
                                (member name
                                        (ico:name-asts declaration-specifier-ast)
                                        :test #'eq :key #'ico:name)))))
    (values (or already-globally-special-p declared-special-p)
            already-globally-special-p)))

;;; Given a single variable bound by some binding form like LET or
;;; LET*, and a list of declaration specifiers concerning that
;;; variable, return a new environment that contains information about
;;; that variable.
(defun augment-environment-with-variable
    (client variable-ast declaration-specifier-asts environment)
  (let ((new-env environment)
        (name (ico:name variable-ast)))
    (multiple-value-bind (special-p globally-p)
        (variable-is-special-p
         client variable-ast declaration-specifier-asts environment)
      (if special-p
          (unless globally-p
            (setf new-env
                  (trucler:add-local-special-variable client new-env name)))
          (setf new-env
                (trucler:add-lexical-variable
                 client new-env name variable-ast))))
    (loop for declaration-specifier-ast in declaration-specifier-asts
          do (setf new-env
                   (typecase declaration-specifier-ast
                     (ico:type-ast
                      ;; FIXME: Do nothing for now since it has not
                      ;; been fully determined how type specifiers are
                      ;; handled by the s-expression-syntax library.
                      new-env)
                     (ico:ignore-ast
                      (trucler:add-variable-ignore
                       client new-env name 'ignore))
                     (ico:ignorable-ast
                      (trucler:add-variable-ignore
                       client new-env name 'ignorable))
                     (ico:dynamic-extent-ast
                      (trucler:add-variable-dynamic-extent
                       client new-env name))
                     (t
                      new-env))))
    new-env))

(defun augment-environment-with-local-function-name
    (client name-ast environment)
  (let* ((name (ico:name name-ast)))
    (trucler:add-local-function client environment name name-ast)))
