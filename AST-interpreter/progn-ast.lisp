(cl:in-package #:common-boot-ast-interpreter)

(defun interpret-implicit-progn-asts (client environment asts)
  (cond ((null asts)
         nil)
        ((null (rest asts))
         (interpret-ast client environment (first asts)))
        (t
         (interpret-ast client environment (first asts))
         (interpret-implicit-progn-asts client environment (rest asts)))))

(defmethod interpret-ast (client environment (ast ico:progn-ast))
  (interpret-implicit-progn-asts client environment (ico:form-asts ast)))
