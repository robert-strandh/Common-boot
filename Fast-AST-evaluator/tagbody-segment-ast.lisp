(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:tagbody-segment-ast))
  `(progn ,@(translate-implicit-progn
             client (ico:statement-asts ast))))
