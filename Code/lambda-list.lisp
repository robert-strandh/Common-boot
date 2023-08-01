(cl:in-package #:common-boot)

(defgeneric finalize-section (client section-ast environment))

(defmethod finalize-section (client (section-ast null) environment)
  environment)

(defgeneric finalize-parameter (client parameter-ast environment))

(defun finalize-parameter-variable (client variable-name-ast environment)
  (let ((variable-name (ico:name variable-name-ast)))
    (multiple-value-bind (special-p globally-special-p)
        (variable-is-special-p
         client
         variable-name-ast
         '()
         environment)
      (change-class variable-name-ast
                    (if special-p
                        'ico:special-variable-bound-ast
                        'ico:variable-definition-ast))
      (if special-p
          (unless globally-special-p
            (trucler:add-local-special-variable
             client environment variable-name))
          (trucler:add-lexical-variable
           client environment variable-name variable-name-ast)))))

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
          (finalize-parameter-variable client name-ast environment))
    (unless (null supplied-p-ast)
      (setf new-environment
            (finalize-parameter-variable client supplied-p-ast environment)))
    new-environment))

(defmethod finalize-parameter
    (client (parameter-ast ico:key-parameter-ast) environment)
  (let ((new-environment environment)
        (name-ast (ico:name-ast parameter-ast))
        (supplied-p-ast (ico:supplied-p-parameter-ast parameter-ast)))
    (setf new-environment
          (finalize-parameter-variable client name-ast environment))
    (unless (null supplied-p-ast)
      (setf new-environment
            (finalize-parameter-variable client supplied-p-ast environment)))
    new-environment))

(defmethod finalize-parameter
    (client (parameter-ast ico:aux-parameter-ast) environment)
  (let ((new-environment environment)
        (name-ast (ico:name-ast parameter-ast)))
    (setf new-environment
          (finalize-parameter-variable client name-ast environment))
    new-environment))

(defmethod finalize-parameter :before
    (client (parameter-ast ico:supplied-p-parameter-ast-mixin) environment)
  (let ((init-form-ast (ico:init-form-ast parameter-ast)))
    (unless (null init-form-ast)
      (reinitialize-instance parameter-ast
        :init-form-ast
        (convert-ast-in-environment client init-form-ast environment)))))

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

;;; FIXME: handle declarations. 

(defgeneric finalize-lambda-list (client environment lambda-list-ast))

;;; Finalize the unparsed parts of an ordinary lambda list AST and
;;; return a new environment resulting from the introduced variables.
(defmethod finalize-lambda-list
    (client environment (ast ico:ordinary-lambda-list-ast))
  (let ((new-environment environment))
    (setf new-environment
          (finalize-section
           client (ico:required-section-ast ast) new-environment))
    (setf new-environment
          (finalize-section
           client (ico:optional-section-ast ast) new-environment))
    (setf new-environment
          (finalize-section
           client (ico:rest-section-ast ast) new-environment))
    (setf new-environment
          (finalize-section
           client (ico:key-section-ast ast) new-environment))
    (setf new-environment
          (finalize-section
           client (ico:aux-section-ast ast) new-environment))
    new-environment))
    
;;; Finalize the unparsed parts of an ordinary lambda list AST and
;;; return a new environment resulting from the introduced variables.
(defmethod finalize-lambda-list
    (client environment (ast ico:specialized-lambda-list-ast))
  (let ((new-environment environment))
    (setf new-environment
          (finalize-section
           client (ico:required-section-ast ast) new-environment))
    (setf new-environment
          (finalize-section
           client (ico:optional-section-ast ast) new-environment))
    (setf new-environment
          (finalize-section
           client (ico:rest-section-ast ast) new-environment))
    (setf new-environment
          (finalize-section
           client (ico:key-section-ast ast) new-environment))
    (setf new-environment
          (finalize-section
           client (ico:aux-section-ast ast) new-environment))
    new-environment))
