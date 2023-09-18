(cl:in-package #:common-boot-ast-walker)

;;;; This system implements a general AST walker.  All it does it
;;;; traverse the AST tree without invoking any action.  To implement
;;;; some action, client code can define an :AROUND method on
;;;; WALK-AST-NODE, that specializes to a particular CLIENT class.
;;;; That around method can then implement actions before or after
;;;; recursive processing takes place, or call WALK-AST-NODE
;;;; recursively with some new AST node.

(defgeneric walk-ast-node (client node))

(defmethod walk-ast-node (client node)
  node)

(defmethod walk-ast-node (client (ast iconoclast:ast))
  (loop for (cardinality slot-reader) in (iconoclast:slot-designators ast)
        do (ecase cardinality
             (*
              (loop for child in (funcall slot-reader ast)
                    do (walk-ast-node client child)))
             (iconoclast:?
              (let ((possible-child (funcall slot-reader ast)))
                (unless (null possible-child)
                  (walk-ast-node client possible-child))))
             (1
              (let ((child (funcall slot-reader ast)))
                (walk-ast-node client child)))))
  ast)

(defvar *visited*)

(defmethod walk-ast-node :around (client node)
  (unless (gethash node *visited*)
    (setf (gethash node *visited*) t)
    (call-next-method)))

(defgeneric walk-ast (client ast))

(defmethod walk-ast (client ast)
  (let ((*visited* (make-hash-table :test #'eq)))
    (walk-ast-node client ast)))
