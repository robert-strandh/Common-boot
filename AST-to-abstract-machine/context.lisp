(cl:in-package #:common-boot-ast-to-abstract-machine)

(defvar *register-numbers*)

(defvar *next-register-number*)

(defvar *dynamic-environment-register*)

(defclass context ()
  ((%next-instruction
    :initarg :next-instruction
    :reader next-instruction)
   ;; This slot contains 0, 1, or :ALL.
   (%values-count
    :initarg :values-count
    :reader values-count)
   (%target-register
    :initarg :target-register
    :reader target-register)))
