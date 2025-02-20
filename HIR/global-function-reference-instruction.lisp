(cl:in-package #:common-boot-hir)

(defclass global-function-reference-instruction (instruction)
  ((%function-name
    :initarg :function-name
    :reader function-name)))
