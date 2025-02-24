(cl:in-package #:common-boot-hir)

(defclass special-variable-reference-instruction (instruction)
  ((%variable-name
    :initarg :variable-name
    :reader variable-name)))
