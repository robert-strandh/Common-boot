(cl:in-package #:common-boot-ast-walker)

(defgeneric walk-ast-node (client node pre-process post-process))

(defmethod walk-ast-node (client node pre-process post-process)
  node)

(defmethod walk-ast-node
    (client (ast iconoclast:ast) pre-process post-process)
  (loop for (cardinality slot-reader) in (iconoclast:slot-designators ast)
        do (ecase cardinality
             (*
              (loop for child in (funcall slot-reader ast)
                    do (walk-ast-node client child pre-process post-process)))
             (iconoclast:?
              (let ((possible-child (funcall slot-reader ast)))
                (unless (null possible-child)
                  (walk-ast-node client possible-child pre-process post-process))))
             (1
              (let ((child (funcall slot-reader ast)))
                (walk-ast-node client child pre-process post-process)))))
  ast)

(defvar *visited*)

(defmethod walk-ast-node :around (client node pre-process post-process)
  (unless (gethash node *visited*)
    (setf (gethash node *visited*) t)
    (call-next-method)))

(defgeneric walk-ast (client ast pre-process post-process))

(defmethod walk-ast (client ast pre-process post-process)
  (let ((*visited* (make-hash-table :test #'eq)))
    (walk-ast-node client ast pre-process post-process)))
