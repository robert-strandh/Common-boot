(cl:in-package #:common-boot)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; CONVERT-CONSTANT is called when a constant is found, either in the
;;; form of a literal or in the form of a constant variable.

(defun convert-literal (client literal environment)
  (declare (ignore client environment))
  (make-instance 'ico:literal-ast
    :literal literal))

(defun convert-constant (client cst environment)
  (declare (ignore client environment))
  (make-instance 'ico:literal-ast
    :origin cst
    :literal (cst:raw cst)))
