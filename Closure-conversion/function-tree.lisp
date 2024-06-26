(cl:in-package #:common-boot-closure-conversion)

;;;; Create a tree of FUNCTION-ASTs.

(defclass function-node ()
  ((%function-ast :initarg :function-ast :reader function-ast)
   (%parent :initarg :parent :reader parent)
   (%children :initform '() :accessor children)))
