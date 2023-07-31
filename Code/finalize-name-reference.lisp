(cl:in-package #:common-boot)

(defgeneric finalize-variable-name-ast-from-description
    (client name-ast description))

(defmethod finalize-variable-name-ast-from-description
    (client
     (name-ast ico:variable-name-ast)
     (description trucler:special-variable-description))
  (change-class name-ast 'ico:special-variable-reference-ast))

(defmethod finalize-variable-name-ast-from-description
    (client
     (name-ast ico:variable-name-ast)
     (description trucler:lexical-variable-description))
  (let ((local-variable-definition-ast (trucler:identity description)))
    (change-class name-ast 'ico:variable-reference-ast
                  :variable-definition-ast
                  local-variable-definition-ast)
    (reinitialize-instance local-variable-definition-ast
      :variable-reference-asts
      (cons name-ast
       (ico:variable-reference-asts local-variable-definition-ast)))))

(defgeneric finalize-function-name-ast-from-description
    (client name-ast description))

(defgeneric finalize-function-name-ast-from-description
    (client name-ast description))

(defmethod finalize-function-name-ast-from-description
    (client
     (name-ast ico:function-name-ast)
     (description trucler:global-function-description))
  (change-class name-ast 'ico:global-function-name-reference-ast))

(defmethod finalize-function-name-ast-from-description
    (client
     (name-ast ico:function-name-ast)
     (description null))
  (change-class name-ast 'ico:global-function-name-reference-ast))

(defmethod finalize-function-name-ast-from-description
    (client
     (name-ast ico:function-name-ast)
     (description trucler:local-function-description))
  (let ((local-function-name-definition-ast (trucler:identity description)))
    (change-class name-ast 'ico:function-reference-ast
                  :local-function-name-definition-ast
                  local-function-name-definition-ast)
    (reinitialize-instance local-function-name-definition-ast
      :local-function-name-reference-asts
      (cons name-ast
       (ico:local-function-name-reference-asts
        local-function-name-definition-ast)))))

(defun finalize-variable-name-ast-from-environment
    (client name-ast environment)
  (finalize-variable-name-ast-from-description
   client name-ast
   (trucler:describe-variable client environment (ico:name name-ast))))

(defun finalize-function-name-ast-from-environment
    (client name-ast environment)
  (finalize-function-name-ast-from-description
   client name-ast
   (trucler:describe-function client environment (ico:name name-ast))))
