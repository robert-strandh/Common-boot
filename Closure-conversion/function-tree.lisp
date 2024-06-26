(cl:in-package #:common-boot-closure-conversion)

;;;; Create a tree of FUNCTION-ASTs.

(defclass function-node ()
  ((%function-ast :initarg :function-ast :reader function-ast)
   (%parent :initarg :parent :reader parent)
   (%children :initform '() :accessor children)))

;;; This variable holds the current FUNCTION-NODE that we are
;;; traversing.  When a new FUNCTION-AST is encountered, this variable
;;; holds the FUNCTION-NODE that will be the parent of the new one, and
;;; then this variable will be bound to the new FUNCTION-NODE.
(defvar *current-function-node*)

(defmethod iaw:walk-ast-node :around ((client client) (ast ico:function-ast))
  (let ((new-node (make-instance 'function-node
                    :function-ast ast
                    :parent *current-function-node*)))
    (push new-node (children *current-function-node*))
    (let ((*current-function-node* new-node))
      (call-next-method))))

(defun create-function-tree (ast)
  (let* ((*current-function-node*
           (make-instance 'function-node
             :function-ast nil
             :parent nil))
         (client (make-instance 'client)))
    (iaw:walk-ast client ast)
    *current-function-node*))
