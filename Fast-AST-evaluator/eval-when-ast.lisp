(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:eval-when-ast))
  `(progn ,@(translate-implicit-progn
             client (ico:form-asts ast))))
