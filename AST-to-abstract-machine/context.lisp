(cl:in-package #:common-boot-ast-to-abstract-machine)

(defvar *register-numbers*)

(defvar *next-register-number*)

(defclass context ()
  ((%next-instruction
    :initarg :next-instruction
    :reader next-instruction)
   (%values-count
    :initarg :values-count
    :reader values-count)))
