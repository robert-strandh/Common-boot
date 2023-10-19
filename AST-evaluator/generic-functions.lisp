(cl:in-package #:common-boot-ast-evaluator)

(defgeneric cps (client ast continuation))

;;; We want CONTINUATION to be a variable so that
;;; There is no risk of duplicating a big lambda
;;; expression. 
(defmethod cps :before (client ast continuation)
  (assert (symbolp continuation)))
