(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:handler-bind-ast))
  ;; Convert the HANDLER form of each binding. 
  ;; FIXME: perhaps do the type specifier too.
  (loop for binding-ast in (ico:binding-asts ast)
        do (convert-ast builder (second binding-ast)))
  ;; Convert the body forms.
  (loop for form-ast in (ico:form-asts ast)
        do (convert-ast builder form-ast)))
