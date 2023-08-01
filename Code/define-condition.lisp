(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:define-condition-ast))
  ;; FIXME: if necessary, handle the superclasses.
  ;; FIXME: handle :REPORT
  (loop for default-initarg-ast in (ico:default-initarg-asts ast)
        do (reinitialize-instance default-initarg-ast
             :initform-ast (convert-ast builder default-initarg-ast))))
