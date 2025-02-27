(cl:in-package #:common-boot-hir)

(defclass instruction ()
  ((%origin
    :initform nil
    :initarg :origin
    :reader origin)
   (%predecessors
    :initform '()
    :initarg :predecessors
    :accessor predecessors)
   (%successors
    :initform '()
    :initarg :successors
    :accessor successors)
   (%inputs
    :initform '()
    :initarg :inputs
    :accessor inputs)
   (%outputs
    :initform '()
    :initarg :outputs
    :accessor outputs)))

(defmethod initialize-instance :after
    ((object instruction)
     &key
       predecessors
       successors
       inputs
       outputs)
  (check-type predecessors list)
  (check-type successors list)
  (check-type inputs list)
  (check-type outputs list))
