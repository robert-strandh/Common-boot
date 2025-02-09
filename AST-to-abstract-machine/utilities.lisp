(cl:in-package #:common-boot-ast-to-abstract-machine)

(defun new-register ()
  (prog1 *next-register-number* (incf *next-register-number*)))
