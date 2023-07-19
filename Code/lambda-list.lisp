(cl:in-package #:common-boot)

(defgeneric finalize-section (client section-ast environment))

(defmethod finalize-section (client (section-ast null) environment)
  environment)

(defgeneric finalize-parameter (client parameter-ast environment))

(defmethod finalize-parameter
    (client (parameter-ast ico:required-parameter-ast) environment)
  (augment-environment-with-variable
   client (ico:name-ast parameter-ast) '() environment environment))

(defmethod finalize-parameter
    (client (parameter-ast ico:rest-parameter-ast) environment)
  (augment-environment-with-variable
   client (ico:name-ast parameter-ast) '() environment environment))

(defmethod finalize-parameter
    (client (parameter-ast ico:optional-parameter-ast) environment)
  (let ((new-environment environment)
        (name-ast (ico:name-ast parameter-ast))
        (supplied-p-ast (ico:supplied-p-parameter-ast parameter-ast)))
    (setf new-environment
          (augment-environment-with-variable
           client name-ast '() environment environment))
    (unless (null supplied-p-ast)
      (setf new-environment
            (augment-environment-with-variable
             client (ico:name-ast supplied-p-ast) '()
             new-environment new-environment)))
    new-environment))

(defmethod finalize-parameter
    (client (parameter-ast ico:key-parameter-ast) environment)
  (let ((new-environment environment)
        (name-ast (ico:name-ast parameter-ast))
        (supplied-p-ast (ico:supplied-p-parameter-ast parameter-ast)))
    (setf new-environment
          (augment-environment-with-variable
           client name-ast '() environment environment))
    (unless (null supplied-p-ast)
      (setf new-environment
            (augment-environment-with-variable
             client (ico:name-ast supplied-p-ast) '()
             new-environment new-environment)))
    new-environment))

(defmethod finalize-parameter
    (client (parameter-ast ico:aux-parameter-ast) environment)
  (let ((new-environment environment)
        (name-ast (ico:name-ast parameter-ast)))
    (setf new-environment
          (augment-environment-with-variable
           client name-ast '() environment environment))
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
                    client parameter-ast new-environment)))))

;;; FIXME: handle declarations. 

;;; Finalize the unparsed parts of an ordinary lambda list AST and
;;; return a new environment resulting from the introduced variables.
(defun finalize-ordinary-lambda-list (client environment ast)
  (let ((new-environment environment))
    (setf new-environment
          (finalize-section
           client (ico:required-section-ast ast) environment))
    (setf new-environment
          (finalize-section
           client (ico:optional-section-ast ast) environment))
    (setf new-environment
          (finalize-section
           client (ico:rest-section-ast ast) environment))
    (setf new-environment
          (finalize-section
           client (ico:key-section-ast ast) environment))
    (setf new-environment
          (finalize-section
           client (ico:aux-section-ast ast) environment))
    new-environment))
    