(cl:in-package #:common-boot-ast-transformations)

(defgeneric canonicalize-declaration-asts (client ast))

(defmethod cbaw:walk-ast-node :around
    ((client client) (ast ico:declaration-asts-mixin))
  (reinitialize-instance ast
    :declaration-asts
    (canonicalize-declaration-asts client (ico:declaration-asts ast)))
  (call-next-method))
