(cl:in-package #:common-boot-fast-ast-evaluator)

(defclass find-local-functions-client ()
  ((%local-functions :initform '() :accessor local-functions)))

(defmethod iaw:walk-ast-node :around
    ((client find-local-functions-client) (ast ico:labels-ast))
  (call-next-method)
  (loop for binding-ast in (ico:binding-asts ast)
        do (push (cons (ico:lambda-list-ast binding-ast)
                       (ico:form-asts binding-ast))
                 (local-functions client)))
  ast)

(defun find-local-functions (ast)
  (let ((client (make-instance 'find-local-functions-client)))
    (iaw:walk-ast client ast)
    (local-functions client)))
