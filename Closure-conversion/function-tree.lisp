(cl:in-package #:common-boot-closure-conversion)

;;;; Create a tree of FUNCTION-ASTs.

(defclass function-node ()
  ((%function-ast :initarg :function-ast :reader function-ast)
   (%parent :initarg :parent :reader parent)
   (%children :initform '() :accessor children)))

;;; This variable holds the current FUNCTION-AST that we are
;;; traversing.  When a new FUNCTION-AST is encountered, this variable
;;; holds the FUNCTION-AST that will be the parent of the new one, and
;;; then this variable will be bound to the new FUNCTION-AST.
(defvar *current-function-ast*)

(defmethod iaw:walk-ast :around ((client client) (ast ico:function-ast))
  (push ast (children *current-function-ast*))
  (let ((*current-function-ast*
          (make-instance 'function-node
            :function-ast ast
            :parent *current-function-ast*)))
    (call-next-method)))

(defun create-function-tree (ast)
  (let ((root (make-instance 'function-node
                :function-ast nil
                :parent nil))
        (client (make-instance 'client)))
    (iaw:walk-ast client ast)
    root))
