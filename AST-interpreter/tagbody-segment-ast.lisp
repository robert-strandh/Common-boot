(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:tagbody-segment-ast))
  (interpret-implicit-progn-asts
   client environment (ico:statement-asts ast)))
