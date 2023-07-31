(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:ecase-ast))
  (reinitialize-instance ast
    :keyform-ast (convert-ast builder (ico:keyform-ast ast)))
  (loop for clause-ast in (ico:clause-asts ast)
        do (reinitialize-instance clause-ast
             :form-asts
             (loop for body-ast in (ico:form-asts clause-ast)
                   collect (convert-ast builder body-ast)))))
