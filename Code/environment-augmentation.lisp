(cl:in-package #:common-boot)

;;; Augment the environment with a single canonicalized declaration
;;; specifier.
(defgeneric augment-environment-with-declaration
    (client
     declaration-identifier
     declaration-identifier-cst
     declaration-data-cst
     environment))

(defmethod augment-environment-with-declaration
    (client
     declaration-identifier
     declaration-identifier-cst
     declaration-data-cst
     environment)
  (warn "Unable to handle declarations specifier: ~s" declaration-identifier)
  environment)

(defmethod augment-environment-with-declaration
    (client
     (declaration-identifier (eql 'dynamic-extent))
     declaration-identifier-cst
     declaration-data-cst
     environment)
  (let ((var-or-function (cst:raw (cst:first declaration-data-cst))))
    (if (consp var-or-function)
        ;; (dynamic-extent (function foo))
        (trucler:add-function-dynamic-extent
         client environment (second var-or-function))
        ;; (dynamic-extent foo)
        (trucler:add-variable-dynamic-extent
         client environment var-or-function))))

(defmethod augment-environment-with-declaration
    (client
     (declaration-identifier (eql 'ftype))
     declaration-identifier-cst
     declaration-data-cst
     environment)
  (trucler:add-function-type
   client environment (second declaration-data-cst) (first declaration-data-cst)))

(defmethod augment-environment-with-declaration
    (client
     (declaration-identifier (eql 'ignore))
     declaration-identifier-cst
     declaration-data-cst
     environment)
  (let ((var-or-function (cst:raw (cst:first declaration-data-cst)))
        (ignore (cst:raw declaration-identifier-cst)))
    (if (consp var-or-function)
        (trucler:add-function-ignore
         client environment (second var-or-function) ignore)
        (trucler:add-variable-ignore
         client environment var-or-function ignore))))

(defmethod augment-environment-with-declaration
    (client
     (declaration-identifier (eql 'ignorable))
     declaration-identifier-cst
     declaration-data-cst
     environment)
  (let ((var-or-function (cst:raw (cst:first declaration-data-cst)))
        (ignore (cst:raw declaration-identifier-cst)))
    (if (consp var-or-function)
        (trucler:add-function-ignore
         client
         environment (second var-or-function) ignore)
        (trucler:add-variable-ignore
         client environment var-or-function ignore))))

(defmethod augment-environment-with-declaration
    (client
     (declaration-identifier (eql 'inline))
     declaration-identifier-cst
     declaration-data-cst
     environment)
  (trucler:add-inline
   client
   environment
   (cst:raw (cst:first declaration-data-cst))
   (cst:raw declaration-identifier-cst)))

(defmethod augment-environment-with-declaration
    (client
     (declaration-identifier (eql 'notinline))
     declaration-identifier-cst
     declaration-data-cst
     environment)
  (trucler:add-inline
   client
   environment
   (cst:raw (cst:first declaration-data-cst))
   (cst:raw declaration-identifier-cst)))

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

(defmethod augment-environment-with-declaration
    (client
     (declaration-identifier (eql 'type))
     declaration-identifier-cst
     declaration-data-cst
     environment)
  (let ((type-cst (cst:first declaration-data-cst))
        (variable-cst (cst:second declaration-data-cst)))
    (trucler:add-variable-type client
                               environment
                               (cst:raw variable-cst)
                               (cst:raw type-cst))))

(defmethod augment-environment-with-declaration
    (client
     (declaration-identifier (eql 'optimize))
     declaration-identifier-cst
     declaration-data-cst
     environment)
  (declare (ignore declaration-identifier-cst declaration-data-cst))
  ;; OPTIMIZE is handled specially, so we do nothing here.
  ;; This method is just for ensuring that the default method,
  ;; which signals a warning, isn't called.
  environment)

;;; Augment the environment with an OPTIMIZE specifier.
(defun augment-environment-with-single-optimize (client optimize environment)
  (let ((quality (if (symbolp optimize) optimize (first optimize)))
        (value (if (symbolp optimize) 3 (second optimize))))
    (ecase quality
      (speed (trucler:add-speed client environment value))
      (compilation-speed (trucler:add-compilation-speed client environment value))
      (safety (trucler:add-safety client environment value))
      (space (trucler:add-space client environment value))
      (debug (trucler:add-debug client environment value)))))

(defun augment-environment-with-optimize (client optimize environment)
  (let ((result environment))
    (loop for single-optimize in optimize
          do (setf result
                   (augment-environment-with-single-optimize
                    client single-optimize result)))
    result))

;;; Extract any OPTIMIZE information from a set of canonicalized
;;; declaration specifiers.
(defun extract-optimize (canonicalized-dspecs)
  (loop for spec in canonicalized-dspecs
        when (eq (cst:raw (cst:first spec)) 'optimize)
          append (loop for remaining = (cst:rest spec)
                         then (cst:rest remaining)
                       until (cst:null remaining)
                       collect (cst:raw (cst:first remaining)))))

;;; Augment the environment with a list of canonical declartion
;;; specifiers.
(defun augment-environment-with-declarations (client environment canonical-dspecs)
  (let ((new-env
          ;; handle OPTIMIZE specially.
          (let ((optimize (extract-optimize canonical-dspecs)))
            (if optimize
                (augment-environment-with-optimize client optimize environment)
                environment))))
    (loop for spec in canonical-dspecs
          for declaration-identifier-cst = (cst:first spec)
          for declaration-identifier = (cst:raw declaration-identifier-cst)
          ;; FIXME: this is probably wrong.  The data may be contained
          ;; in more than one element. 
          for declaration-data-cst = (cst:rest spec)
          do (setf new-env
                   (augment-environment-with-declaration
                    client
                    declaration-identifier
                    declaration-identifier-cst
                    declaration-data-cst
                    new-env)))
    new-env))

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
;;; LET*, and a list of canonical declaration specifiers
;;; concerning that variable, return a new environment that contains
;;; information about that variable.
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
