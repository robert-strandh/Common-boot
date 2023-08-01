(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:slot-specifier-ast))
  (reinitialize-instance ast
    :initform-ast
    (if (null (ico:initform-ast ast))
        nil
        (convert-ast builder (ico:initform-ast ast))))
  (loop for reader-ast in (ico:reader-asts ast)
        do (change-class reader-ast 'ico:global-function-name-reference-ast))
  (loop for reader-ast in (ico:writer-asts ast)
        do (change-class reader-ast 'ico:global-function-name-reference-ast))
  (loop for reader-ast in (ico:accessor-asts ast)
        do (change-class reader-ast 'ico:global-function-name-reference-ast)))

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:defclass-ast))
  ;; FIXME: if necessary, handle the superclasses.
  (loop for default-initarg-ast in (ico:default-initarg-asts ast)
        do (reinitialize-instance default-initarg-ast
             :initform-ast (convert-ast builder default-initarg-ast))))
