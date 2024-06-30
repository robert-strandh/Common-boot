(cl:in-package #:common-boot-closure-conversion)

;;; This AST has the same shape as a LET-AST, but the
;;; VARIABLE-DEFINITION-AST of a binding is guaranteed not to be
;;; captured.

(defclass let-temporary-ast
    (ico:binding-asts-mixin
     ico:implicit-progn-ast-mixin
     ico:ast)
  ())

;;; This AST creates a new cell which becomes the value of the AST.

(defclass make-cell-ast (ico:form-asts-mixin ico:ast)
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

;;; This AST has two slot, a VARIABLE-REFERENCE-AST corresponding to a
;;; VARIABLE-DEFINITION-AST introduced by a a binding with a
;;; MAKE-CELL-AST as the FORM-AST, and a FORM-AST that determines the
;;; value to be written to the cell.  When a variable is both shared
;;; and assigned to, so that its vale is contained in a cell, then
;;; each SETQ-AST in which the VARIABLE-REFERENCE-AST refers to the
;;; original VARIABLE-REFERENCE-AST will be replaced by an instance of
;;; this AST class, such that the VARIABLE-REFERENCE-AST in this
;;; instance corresponds to a VARIABLE-DEFINITION-AST introduced by a
;;; a binding with a MAKE-CELL-AST as the FORM-AST.  The FORM-AST will
;;; then be the same as the original FORM-AST in the SETQ-AST.

(defclass write-cell-ast (ico:ast)
  ((%variable-reference-ast
    :initarg :variable-reference-ast
    :reader variable-reference-ast)
   (%form-ast
    :initarg :form-ast
    :reader form-ast)))

;;; This AST class is a subclass of LOCAL-FUNCTION-AST, and it has an
;;; additional slot for the static environment.

(defclass static-function-ast (ico:local-function-ast)
  ((%static-environment :accessor static-environment)))
