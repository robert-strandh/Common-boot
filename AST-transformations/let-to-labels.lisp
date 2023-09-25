(cl:in-package #:common-boot-ast-transformations)

;;;; This function turns an AST representing an LET form into an AST
;;;; representing a LABELS form. 

(defclass let-to-labels-client (client) ())

(defun bindings-and-body-to-labels
    (binding-asts declaration-asts form-asts)
  (let* ((local-function-definition
           (make-instance 'ico:local-function-name-definition-ast
             :name (gensym)))
         (local-function-reference
           (make-instance 'ico:function-reference-ast
             :local-function-name-definition-ast local-function-definition)))
    (reinitialize-instance local-function-definition
      :local-function-name-reference-asts (list local-function-reference))
    (make-instance 'ico:labels-ast
      :binding-asts
      (list (make-instance 'ico:local-function-ast
              :name-ast local-function-definition
              :lambda-list-ast
              (make-instance 'ico:ordinary-lambda-list-ast
                :required-section-ast
                (make-instance 'ico:required-section-ast
                  :parameter-asts
                  (loop for binding-ast in binding-asts
                        for variable-name-ast
                          = (ico:variable-name-ast binding-ast)
                        collect (make-instance 'ico:required-parameter-ast
                                  :name-ast variable-name-ast))))
              :declaration-asts declaration-asts
              :form-asts form-asts))
      :form-asts
      (list (make-instance 'ico:application-ast
              :function-name-ast local-function-reference
              :argument-asts
              (mapcar #'ico:form-ast binding-asts))))))

(defmethod cbaw:walk-ast-node :around
    ((client let-to-labels-client) (ast ico:let-ast))
  ;; Start by converting any children of this AST node.
  (call-next-method)
  (bindings-and-body-to-labels
   (ico:binding-asts ast) (ico:declaration-asts ast) (ico:form-asts ast)))

(defun let-to-labels (ast)
  (let ((client (make-instance 'let-to-labels-client)))
    (cbaw:walk-ast client ast)))
