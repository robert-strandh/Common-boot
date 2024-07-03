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

;;; This AST is used to set the static environment of an instance of
;;; STATIC-FUNCTION-AST.  The slot LOCAL-FUNCTION-REFERENCE-AST
;;; contains a FUNCTION-REFERENCE-AST that refers to the
;;; STATIC-FUNCTION-AST.  This class is a subclass of FORM-ASTS-MIXIN,
;;; so that it contains a list of FORM-ASTs, one for each element of
;;; the static environment to be set.

(defclass set-static-environment-ast (ico:form-asts-mixin ico:ast)
  ((%local-function-reference-ast
    :initarg local-function-reference-ast
    :reader local-function-reference-ast)))

;;; This AST is used to access an object in the static environment of
;;; the current function.  It has a an INDEX slot that contains the
;;; index of the object in the static environment.  The value of this
;;; AST is the object.

(defclass read-static-environment-ast (ico:ast)
  ((%index :initarg :index :reader index)))
