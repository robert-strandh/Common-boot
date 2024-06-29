(cl:in-package #:common-boot-closure-conversion)

;;; This AST has the same shape as a LET-AST, but the lexical variable
;;; introduced by a binding contains a cell with a contents defined by
;;; the corresponding FORM-AST.
;;;
;;; When a variable introduced by a LOCAL-FUNCTION-AST must be
;;; contained in a cell because it is both shared and assigned to, the
;;; body of the LOCAL-FUNCTION-AST can be wrapped in one of these
;;; ASTs.  A reference to the original variable is then replaced by a
;;; READ-CELL-AST, and a SETQ-AST that assigns to the original
;;; variable is replaced by a WRITE-CELL-AST.

(defclass let-cell-ast
    (ico:binding-asts-mixin
     ico:implicit-progn-ast-mixin
     ico:ast)
  ())
