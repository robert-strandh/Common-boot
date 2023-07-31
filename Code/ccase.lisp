(cl:in-package #:common-boot)

(defmethod abp:finish-node
    ((builder builder)
     (kind t)
     (ast ico:ccase-ast))
  (reinitialize-instance ast
    :keyplace-ast (convert-ast builder (ico:keyplace-ast ast)))
  (loop for clause-ast in (ico:clause-asts ast)
        do (reinitialize-instance clause-ast
             :form-asts
             (loop for body-ast in (ico:form-asts clause-ast)
                   collect (convert-ast builder body-ast)))))
