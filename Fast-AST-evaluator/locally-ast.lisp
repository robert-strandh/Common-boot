(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:locally-ast))
  (let ((body-asts (ico:form-asts ast)))
    `(progn ,@(translate-implicit-progn client body-asts))))
