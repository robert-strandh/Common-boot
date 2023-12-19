(cl:in-package #:common-boot)

(defgeneric finalize-section (client section-ast environment))

(defmethod finalize-section (client (section-ast null) environment )
  environment)

(defgeneric finalize-parameter (client parameter-ast environment))

(defun finalize-parameter-variable (client variable-name-ast environment)
  (let ((name (ico:name variable-name-ast)))
    (cond ((typep (trucler:describe-variable client environment name)
                  'trucler:global-special-variable-description)
           (change-class variable-name-ast
                         'ico:special-variable-bound-ast)
           environment)
          ((typep variable-name-ast 'ico:special-variable-bound-ast)
           (trucler:add-local-special-variable client environment name))
          (t
           (change-class variable-name-ast 'ico:variable-definition-ast)
           (trucler:add-lexical-variable
            client environment name variable-name-ast)))))

(defmethod finalize-parameter
    (client (parameter-ast ico:required-parameter-ast) environment)
  (finalize-parameter-variable
   client (ico:name-ast parameter-ast) environment))

(defmethod finalize-parameter
    (client (parameter-ast ico:rest-parameter-ast) environment)
  (finalize-parameter-variable
   client (ico:name-ast parameter-ast) environment))

(defmethod finalize-parameter
    (client (parameter-ast ico:optional-parameter-ast) environment)
  (let ((new-environment environment)
        (name-ast (ico:name-ast parameter-ast))
        (supplied-p-ast (ico:supplied-p-parameter-ast parameter-ast)))
    (setf new-environment
          (finalize-parameter-variable client name-ast new-environment))
    (unless (null supplied-p-ast)
      (setf new-environment
            (finalize-parameter-variable client supplied-p-ast new-environment)))
    new-environment))

(defmethod finalize-parameter
    (client (parameter-ast ico:key-parameter-ast) environment)
  (let ((new-environment environment)
        (name-ast (ico:name-ast parameter-ast))
        (supplied-p-ast (ico:supplied-p-parameter-ast parameter-ast)))
    (setf new-environment
          (finalize-parameter-variable client name-ast new-environment))
    (unless (null supplied-p-ast)
      (setf new-environment
            (finalize-parameter-variable client supplied-p-ast new-environment)))
    new-environment))

(defmethod finalize-parameter
    (client (parameter-ast ico:aux-parameter-ast) environment)
  (let ((new-environment environment)
        (name-ast (ico:name-ast parameter-ast)))
    (setf new-environment
          (finalize-parameter-variable client name-ast new-environment))
    new-environment))

(defmethod finalize-parameter :before
    (client (parameter-ast ico:supplied-p-parameter-ast-mixin) environment)
  (let ((init-form-ast (ico:init-form-ast parameter-ast)))
    (unless (null init-form-ast)
      (reinitialize-instance parameter-ast
        :init-form-ast
        (convert-ast-in-environment client init-form-ast environment)))))

(defmethod finalize-parameter :before
    (client (parameter-ast ico:aux-parameter-ast) environment)
  (let ((form-ast (ico:form-ast parameter-ast)))
    (unless (null form-ast)
      (reinitialize-instance parameter-ast
        :form-ast
        (convert-ast-in-environment client form-ast environment)))))

(defmethod finalize-section
    (client (section-ast ico:single-parameter-section-ast) environment)
  (finalize-parameter client (ico:parameter-ast section-ast) environment))

(defmethod finalize-section
    (client (section-ast ico:multi-parameter-section-ast) environment)
  (let ((new-environment environment))
    (loop for parameter-ast in (ico:parameter-asts section-ast)
          do (setf new-environment
                   (finalize-parameter
                    client parameter-ast new-environment)))
    new-environment))

;;; We account for the possibility of the lambda list to contain
;;; duplicate variables, just like a LET* can.  So the variable
;;; referred to by some SPECIAL declaration is the rightmost one with
;;; that name in the lambda list.  Therefore, we traverse the list of
;;; variables in the lambda list in reverse order.
(defun mark-variable-ast-as-special (lambda-list-ast variable-name-ast)
  (let* ((variable-asts
           (iat:extract-variable-asts-in-lambda-list lambda-list-ast)))
    (loop for variable-ast in (reverse variable-asts)
          do (when (eq (ico:name variable-ast)
                       (ico:name variable-name-ast))
               (change-class variable-ast 'ico:special-variable-bound-ast)
               (return)))))

(defun mark-variable-asts-as-special (lambda-list-ast variable-name-asts)
  (loop for variable-name-ast in variable-name-asts
        do (mark-variable-ast-as-special lambda-list-ast variable-name-ast)))

(defgeneric lambda-list-section-accessors (ast))

(defmethod lambda-list-section-accessors
    ((ast ico:ordinary-lambda-list-ast))
  (list #'ico:required-section-ast
        #'ico:optional-section-ast
        #'ico:rest-section-ast
        #'ico:key-section-ast
        #'ico:aux-section-ast))

(defmethod lambda-list-section-accessors
    ((ast ico:specialized-lambda-list-ast))
  (list #'ico:required-section-ast
        #'ico:optional-section-ast
        #'ico:rest-section-ast
        #'ico:key-section-ast
        #'ico:aux-section-ast))

(defmethod lambda-list-section-accessors
    ((ast ico:destructuring-lambda-list-ast))
  (list #'ico:whole-section-ast
        #'ico:required-section-ast
        #'ico:optional-section-ast
        #'ico:rest-section-ast
        #'ico:key-section-ast
        #'ico:aux-section-ast))

(defmethod lambda-list-section-accessors
    ((ast ico:macro-lambda-list-ast))
  (list #'ico:whole-section-ast
        #'ico:environment-section-ast
        #'ico:required-section-ast
        #'ico:optional-section-ast
        #'ico:rest-section-ast
        #'ico:key-section-ast
        #'ico:aux-section-ast))

(defgeneric finalize-lambda-list
    (client environment lambda-list-ast declaration-asts))

(defmethod finalize-lambda-list
    (client environment (ast ico:lambda-list-ast) declaration-asts)
  (let ((new-environment environment)
        (special-declared-variable-asts
          (iat:extract-special-declared-variable-asts declaration-asts)))
    (mark-variable-asts-as-special ast special-declared-variable-asts)
    (loop for accessor in (lambda-list-section-accessors ast)
          do (setf new-environment
                   (finalize-section
                    client (funcall accessor ast) new-environment)))
    (loop for special-declared-variable-ast in special-declared-variable-asts
          for name = (ico:name special-declared-variable-ast)
          for description
            = (trucler:describe-variable client new-environment name)
          unless (typep description 'trucler:special-variable-description)
            do (setf new-environment
                     (trucler:add-local-special-variable
                      client new-environment name)))
    new-environment))
