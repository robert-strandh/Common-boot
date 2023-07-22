(cl:in-package #:common-boot)

;;; For binding forms such as LET and LET*, we need to split a bunch
;;; of declaration specifiers into those that are bound and those that
;;; are free.  For the bound ones, we need to figure out, for each
;;; variable being bound in the binding form, which declaration
;;; specifiers apply to that variable.  We do this by taking a list of
;;; DECLARATION-SPECIFIER-ASTs, and a VARIABLE-NAME-AST and split the
;;; list into those that apply to the variable represented by the
;;; VARIABLE-NAME-AST, and those that don't.  we return those two
;;; lists as two values.

(defun split-declaration-specifier-asts
    (declaration-specifier-asts variable-name-ast)
  (let ((name (ico:name variable-name-ast))
        (result '())
        (remaining '()))
    (loop for declaration-specifier-ast in declaration-specifier-asts
          do (typecase declaration-specifier-ast
               ((or ico:dynamic-extent-ast
                    ico:type-ast
                    ico:ignore-ast
                    ico:ignorable-ast
                    ico:special-ast)
                (let ((name-asts (ico:name-asts declaration-specifier-ast)))
                  (if (loop for name-ast in name-asts
                              thereis (and (typep name-ast
                                                  'ico:variable-name-ast)
                                           (eq (ico:name name-ast) name)))
                      (push declaration-specifier-ast result)
                      (push declaration-specifier-ast remaining))))
               (t
                (push declaration-specifier-ast remaining))))
    (values (nreverse result) (nreverse remaining))))
