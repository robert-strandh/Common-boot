(cl:in-package #:common-boot-fast-ast-evaluator)

(defclass find-local-functions-client ()
  ((%local-functions :initform '() :accessor local-functions)))

(defmethod iaw:walk-ast-node :around
    ((client find-local-functions-client) (ast ico:labels-ast))
  (call-next-method)
  (setf (local-functions client)
        (append (ico:binding-asts ast) (local-functions client)))
  ast)

(defun find-local-function-asts (ast)
  (let ((client (make-instance 'find-local-functions-client)))
    (iaw:walk-ast client ast)
    (local-functions client)))
