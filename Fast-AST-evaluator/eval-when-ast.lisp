(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:eval-when-ast))
  `(progn ,@(translate-implicit-progn
             client environment (ico:form-asts ast))))
