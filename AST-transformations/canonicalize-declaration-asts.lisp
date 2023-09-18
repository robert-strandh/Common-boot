(cl:in-package #:common-boot-ast-transformations)

(defgeneric canonicalize-declaration-specifier-ast
    (client declaration-specifier-ast))

(defmethod canonicalize-declaration-specifier-ast
    (client declaration-specifier-ast))

(defmethod cbaw:walk-ast-node :around
    ((client client) (ast ico:declaration-asts-mixin))
  (reinitialize-instance ast
    :declaration-asts
    (loop for declaration-ast in (ico:declaration-asts ast)
          append (loop for declaration-specifier-ast
                         in (ico:declaration-specifier-asts declaration-ast)
                       append (canonicalize-declaration-specifier-ast
                               declaration-specifier-ast))))
  (call-next-method))
