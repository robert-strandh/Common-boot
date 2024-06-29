(cl:in-package #:common-boot-closure-conversion)

;;; This AST has the same shape as a LET-AST, but the
;;; VARIABLE-DEFINITION-AST of a binding will contain a cell with a
;;; contents defined by the corresponding FORM-AST.
;;;
;;; When a VARIABLE-DEFINITION-AST introduced by a LOCAL-FUNCTION-AST
;;; must be contained in a cell because it is both shared and assigned
;;; to, the body of the LOCAL-FUNCTION-AST can be wrapped in one of
;;; these ASTs.  A VARIABLE-REFERENCE-AST corresponding to the
;;; VARIABLE-DEFINITION-AST is then replaced by a READ-CELL-AST, and a
;;; SETQ-AST that assigns to the VARIABLE-REFERENCE-AST corresponding
;;; to the VARIABLE-DEFINITION-AST is then replaced by a
;;; WRITE-CELL-AST.

(defclass let-cell-ast
    (ico:binding-asts-mixin
     ico:implicit-progn-ast-mixin
     ico:ast)
  ())

;;; This AST has a slot that contains a VARIABLE-REFERENCE-AST
;;; corresponding to a VARIABLE-DEFINITION-AST introduced by a
;;; LET-CELL-AST.  The value of the AST is the contents of the cell
;;; introduced by the LET-CELL-AST.  When a variable is both shared
;;; and assigned to, so that its vale is contained in a cell, then the
;;; original VARIABLE-REFERENCE-AST is replaced by a READ-CELL-AST
;;; as described.

(defclass read-cell-ast (ico:ast)
  ((%variable-reference-ast
    :initarg :variable-reference-ast
    :reader variable-reference-ast)))
