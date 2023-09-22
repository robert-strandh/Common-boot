(cl:in-package #:common-boot-ast-transformations)

;;;; Special bindings have already been taken into account when every
;;;; VARIABLE-NAME-AST is turned into either a VARIABLE-DEFINITION-AST
;;;; (if the variable is lexical) or a SPECIAL-VARIABLE-BOUND-AST (if
;;;; the variable is special).  So, unless needed for some other
;;;; purpose, SPECIAL declarations can be removed without changing the
;;;; semantics, as they are not going to be consulted again.

(defmethod cbaw:walk-ast-node :around
    ((client client) (ast ico:declaration-asts-mixin))
  (loop for declaration-ast in (ico:declaration-asts ast)
        do (reinitialize-instance declaration-ast
             :declaration-specifier-asts
             (remove-if (lambda (declaration-specifier-ast)
                          (typep declaration-specifier-ast
                                 'ico:special-ast))
                        (ico:declaration-specifier-asts ast))))
  (call-next-method))
