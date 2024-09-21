(cl:in-package #:common-boot)

(defclass stack-entry ()
  ((%origin :initarg :origin :reader origin)
   (%called-function :initarg :called-function :reader called-function)
   (%arguments :initarg :arguments :reader arguments)))

(defparameter *stack* '())
