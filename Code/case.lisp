(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:case-ast))
  (reinitialize-instance ast
    :keyform-ast (convert-ast builder (ico:keyform-ast ast)))
  (loop for clause-ast in (ico:clause-asts ast)
        do (reinitialize-instance clause-ast
             :form-asts (convert-asts builder (ico:form-asts clause-ast)))))
