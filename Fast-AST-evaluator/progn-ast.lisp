(cl:in-package #:common-boot-fast-ast-evaluator)

(defun translate-implicit-progn (client asts)
  (loop for ast in asts
        collect (translate-ast client ast)))
  

(defmethod translate-ast (client (ast ico:progn-ast))
  `(progn
     ,@(translate-implicit-progn client (ico:form-asts ast))))
