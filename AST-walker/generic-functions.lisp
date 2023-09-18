(cl:in-package #:common-boot-ast-walker)

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
