(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:locally-ast))
  (let ((body-asts (ico:form-asts ast)))
    `(progn ,@(translate-implicit-progn client environment body-asts))))
