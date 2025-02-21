(cl:in-package #:common-boot-hir)

;;; The LAMBDA-LIST slot contains a "lexified lambda list" as defined
;;; by the AST transformation LEXIFY-LAMBDA-LIST in Iconoclast, except
;;; that the VARIABLE-ASTs have been replaced by registers.

;;; This instruction has only outputs.  It has one output for each
;;; required parameter.  It has two outputs for each &OPTIONAL
;;; parameter, one for the parameter itself and one for the SUPPLIED-P
;;; parameter.  If the lambda list contains &REST, then this
;;; instruction has one output for that parameter.  It has two outputs
;;; for each &KEY parmeter one for the parameter itself and one for
;;; the SUPPLIED-P parameter.

(defclass parse-arguments-instruction (instruction)
  ((%lambda-list
    :initarg :lambda-list
    :reader lambda-list)
   (%static-environment-register
    :initarg :static-environment-register
    :reader static-environment-register)
   (%dynamic-environment-register
    :initarg :dynamic-environment-register
    :reader dynamic-environment-register)))
