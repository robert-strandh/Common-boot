(cl:in-package #:common-boot-closure-conversion)

;;; This AST has the same shape as a LET-AST, but the
;;; VARIABLE-DEFINITION-AST of a binding is guaranteed not to be
;;; captured.

(defclass let-temporary-ast
    (ico:binding-asts-mixin
     ico:implicit-progn-ast-mixin
     ico:ast)
  ())

;;; This AST has a slot that contains a VARIABLE-REFERENCE-AST
;;; corresponding to a VARIABLE-DEFINITION-AST introduced by a a
;;; binding with a MAKE-CELL-AST as the FORM-AST.  The value of the
;;; AST is the contents of the cell.  When a variable is both shared
;;; and assigned to, so that its vale is contained in a cell, then the
;;; original VARIABLE-REFERENCE-AST is replaced by a READ-CELL-AST as
;;; described.

(defclass read-cell-ast (ico:ast)
  ((%variable-reference-ast
    :initarg :variable-reference-ast
    :reader variable-reference-ast)))
