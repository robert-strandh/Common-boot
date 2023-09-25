(cl:in-package #:common-boot-ast-transformations)

;;;; This function turns an AST representing a form such as:
;;;;
;;;;    ((LAMBDA <lambda-list> <body>) <argument>*)
;;;;
;;;; Into:
;;;;
;;;;    (LABELS ((<name> <lambda-list> <body>)) (<name> <argument>*)
;;;;
;;;; where <name> is a generated symbol.

(defclass application-lambda-to-labels-client (client) ())

(defmethod cbaw:walk-ast-node :around
    ((client application-lambda-to-labels-client) (ast ico:application-ast))
  ;; Start by converting any children of this AST node.
  (call-next-method)
  (if (typep (ico:function-name-ast ast) 'ico:lambda-expression-ast)
      (let* ((function-name-definition-ast
               (make-instance 'ico:local-function-name-definition-ast
                 :name (gensym)))
             (function-name-reference-ast
               (make-instance 'ico:function-reference-ast
                 :local-function-name-definition-ast
                 function-name-definition-ast)))
        (reinitialize-instance function-name-definition-ast
          :local-function-name-reference-asts
          (list function-name-reference-ast))
        (make-instance 'ico:labels-ast
          :binding-asts
          (list (make-instance 'ico:local-function-ast
                  :name-ast function-name-definition-ast
                  :lambda-list-ast (ico:lambda-list-ast ast)
                  :declaration-asts (ico:declaration-asts ast)
                  :form-asts (ico:form-asts ast)
                  :origin (ico:origin ast)))
          :form-asts
          (list (make-instance 'ico:application-ast
                  :function-name-ast function-name-reference-ast
                  :argument-asts (ico:argument-asts ast)
                  :origin (ico:origin ast)))))
      ast))
                  
(defun application-lambda-to-labels (ast)
  (let ((client (make-instance 'application-lambda-to-labels-client)))
    (cbaw:walk-ast client ast)))
