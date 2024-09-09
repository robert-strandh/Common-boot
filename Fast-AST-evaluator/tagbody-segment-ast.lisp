(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client environment (ast ico:tagbody-segment-ast))
  `(progn ,@(translate-implicit-progn
             client environment (ico:statement-asts ast))))
