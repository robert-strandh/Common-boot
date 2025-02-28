(cl:in-package #:common-boot-ast-to-hir)

(defmethod translate-ast (client (ast ico:multiple-value-prog1-ast))
  (let* ((target-register *target-register*)
         (*target-register* nil)
         (*next-instruction*
           (translate-implicit-progn client (ico:form-asts ast)))
         (*target-register* target-register))
    (translate-ast client (ico:values-ast ast))))
