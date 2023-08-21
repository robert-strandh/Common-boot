(cl:in-package #:common-boot-ast-evaluator)

;;; We just ignore the value type which is perfectly allowed by the
;;; standard.
(defmethod cps (client (ast ico:the-ast) continuation)
  (cps client (ico:form-ast ast) continuation))
