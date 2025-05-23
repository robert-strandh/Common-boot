(cl:in-package #:common-boot)

;;; Given a list of bound declaration ASTs that each has a reference
;;; to the variable in represented by VARIABLE-NAME-AST, change the
;;; class of that reference to either VARIABLE-REFERENCE-AST or
;;; SPECIAL-VARIABLE-REFERENCE-AST according to whether
;;; VARIABLE-NAME-AST is a VARIABLE-DEFINITION-AST or a
;;; SPECIAL-VARIABLE-BOUND-AST.  In the first case, also tie the
;;; definition and the reference together.
(defun change-class-of-variable-references
    (variable-name-ast bound-declaration-asts)
  (loop for bound-declaration-ast in bound-declaration-asts
        do (loop for name-ast in (ico:name-asts bound-declaration-ast)
                 do (when (eq (ico:name variable-name-ast)
                              (ico:name name-ast))
                      (if (typep variable-name-ast
                                 'ico:variable-definition-ast)
                          (progn
                            (change-class
                             name-ast
                             'ico:variable-reference-ast
                             :definition-ast variable-name-ast)
                            (reinitialize-instance variable-name-ast
                              :reference-asts
                              (cons name-ast
                               (ico:reference-asts
                                variable-name-ast))))
                          (change-class
                           name-ast
                           'ico:special-variable-reference-ast))))))

(defgeneric finalize-variable-name-ast-using-description
    (description variable-name-ast))

(defmethod finalize-variable-name-ast-using-description
    ((description trucler:lexical-variable-description) variable-name-ast)
  (let* ((variable-definition-ast (trucler:identity description))
         (result (make-instance 'ico:variable-reference-ast
                   :name (ico:name variable-name-ast)
                   :origin (ico:origin variable-name-ast)
                   :definition-ast variable-definition-ast)))
    (reinitialize-instance variable-definition-ast
      :reference-asts
      (append (ico:reference-asts variable-definition-ast)
              (list result)))
    result))

(defmethod finalize-variable-name-ast-using-description
    ((description trucler:special-variable-description) variable-name-ast)
  (make-instance 'ico:special-variable-reference-ast
    :name (ico:name variable-name-ast)
    :origin (ico:origin variable-name-ast)))

(defgeneric finalize-function-name-ast-using-description
    (description function-name-ast))

(defmethod finalize-function-name-ast-using-description
    ((description trucler:local-function-description) function-name-ast)
  (let* ((function-definition-ast (trucler:identity description))
         (result (make-instance 'ico:function-reference-ast
                   :definition-ast
                   function-definition-ast
                   :name (ico:name function-name-ast)
                   :origin (ico:origin function-name-ast))))
    (reinitialize-instance function-definition-ast
      :reference-asts
      (append (ico:reference-asts
               function-definition-ast)
              (list result)))
    result))

(defmethod finalize-function-name-ast-using-description
    ((description trucler:global-function-description)
     function-name-ast)
  (make-instance 'ico:global-function-name-reference-ast
    :name (ico:name function-name-ast)
    :origin (ico:origin function-name-ast)))

(defgeneric finalize-name-ast (client name-ast environment))

(defmethod finalize-name-ast
    (client (name-ast ico:variable-name-ast) environment)
  (let* ((name (ico:name name-ast))
         (description (trucler:describe-variable client environment name)))
    (finalize-variable-name-ast-using-description
     description name-ast)))

(defmethod finalize-name-ast
    (client (name-ast ico:function-name-ast) environment)
  (let* ((name (ico:name name-ast))
         (description (trucler:describe-function client environment name)))
    (finalize-function-name-ast-using-description
     description name-ast)))
  
(defun finalize-simple-declaration-specifier-ast
    (client declaration-specifier-ast environment)
  (reinitialize-instance declaration-specifier-ast
    :name-asts
    (loop for name-ast in (ico:name-asts declaration-specifier-ast)
          collect (finalize-name-ast client name-ast environment))))

(defgeneric finalize-declaration-specifier-ast
    (client declaration-specifier-ast environment))

(defmethod finalize-declaration-specifier-ast
    (client (declaration-specifier-ast ico:dynamic-extent-ast) environment)
  (finalize-simple-declaration-specifier-ast
   client declaration-specifier-ast environment))

(defmethod finalize-declaration-specifier-ast
    (client (declaration-specifier-ast ico:ignore-ast) environment)
  (finalize-simple-declaration-specifier-ast
   client declaration-specifier-ast environment))

(defmethod finalize-declaration-specifier-ast
    (client (declaration-specifier-ast ico:ignorable-ast) environment)
  (finalize-simple-declaration-specifier-ast
   client declaration-specifier-ast environment))

(defmethod finalize-declaration-specifier-ast
    (client (declaration-specifier-ast ico:inline-ast) environment)
  (finalize-simple-declaration-specifier-ast
   client declaration-specifier-ast environment))

(defmethod finalize-declaration-specifier-ast
    (client (declaration-specifier-ast ico:notinline-ast) environment)
  (finalize-simple-declaration-specifier-ast
   client declaration-specifier-ast environment))

(defmethod finalize-declaration-specifier-ast
    (client (declaration-specifier-ast ico:special-ast) environment)
  (finalize-simple-declaration-specifier-ast
   client declaration-specifier-ast environment))

(defmethod finalize-declaration-specifier-ast
    (client (declaration-specifier-ast ico:optimize-ast) environment)
  declaration-specifier-ast)

;;; FIXME: add methods on FINALIZE-DECLARATION-SPECIFIER-AST for TYPE
;;; and FTYPE once we know how to handle those.

(defun finalize-declaration-ast (client declaration-ast environment)
  (loop for declaration-specifier-ast
          in (ico:declaration-specifier-asts declaration-ast)
        do (finalize-declaration-specifier-ast
            client declaration-specifier-ast environment)))

(defun finalize-declaration-asts (client declaration-asts environment)
  (loop for declaration-ast in declaration-asts
        do (finalize-declaration-ast client declaration-ast environment)))
