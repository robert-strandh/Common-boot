(cl:in-package #:common-boot-ast-to-abstract-machine)

(defclass context ()
  ((%next-instruction :initarg :next-instruction :reader next-instruction)
   (%values-count :initarg :values-count :reader values-count)))
