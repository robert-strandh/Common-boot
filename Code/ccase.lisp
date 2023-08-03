(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:ccase-ast))
  (reinitialize-instance ast
    :keyplace-ast (convert-ast builder (ico:keyplace-ast ast)))
  (loop for clause-ast in (ico:clause-asts ast)
        do (reinitialize-instance clause-ast
             :form-asts (convert-asts builder (ico:form-asts clause-ast)))))
