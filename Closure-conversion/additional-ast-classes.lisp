(cl:in-package #:common-boot-closure-conversion)

;;; This AST has the same shape as a LET-AST, but the lexical variable
;;; introduced by a binding contains a cell with a contents defined by
;;; the corresponding FORM-AST.
(defclass let-cell-ast
    (ico:binding-asts-mixin
     ico:implicit-progn-ast-mixin
     ico:ast)
  ())
