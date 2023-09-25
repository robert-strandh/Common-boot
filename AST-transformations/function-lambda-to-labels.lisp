(cl:in-package #:common-boot-ast-transformations)

;;;; This function turns an AST representing a form such as:
;;;;
;;;;    (FUNCTION (LAMBDA <lambda-list> <body>))
;;;;
;;;; Into:
;;;;
;;;;    (LABELS ((<name> <lambda-list> <body>)) (FUNCTION <name>)) 
;;;;
;;;; where <name> is a generated symbol.

(defclass function-lambda-to-labels-client (client) ())

(defmethod cbaw:walk-ast-node :around
    ((client function-lambda-to-labels-client) (ast ico:function-ast))
  ;; Start by converting any children of this AST node.
  (call-next-method)
  (if (typep (ico:name-ast ast) 'ico:lambda-expression-ast)
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
          (list (make-instance 'ico:function-ast
                  :name-ast function-name-reference-ast
                  :origin (ico:origin ast)))))
      ast))
                  
(defun function-lambda-to-labels (ast)
  (let ((client (make-instance 'function-lambda-to-labels-client)))
    (cbaw:walk-ast-node client ast)))
