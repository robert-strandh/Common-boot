(cl:in-package #:common-boot-fast-ast-evaluator)

(defun translate-implicit-progn (client environment asts)
  `(progn ,(loop for ast in asts
                 collect (translate-ast client environment ast))))
  

(defmethod translate-ast (client environment (ast ico:progn-ast))
  (translate-implicit-progn client environment (ico:form-asts ast)))
