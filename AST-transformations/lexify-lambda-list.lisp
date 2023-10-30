(cl:in-package #:common-boot-ast-transformations)

;;;; This transformation applies to AST types that have an ordinary
;;;; lambda list.  It applies in four cases:
;;;;
;;;;   1. One of the parameters (including SUPPLIED-P parameters) is
;;;;      a special variable.
;;;;
;;;;   2. One of the &OPTIONAL or &KEY parameters lacks a SUPPLIED-P
;;;;      parameter.
;;;; 
;;;;   3. One of the &OPTIONAL or &KEY parameters has an INIT-FORM
;;;;      other than NIL.
;;;; 
;;;;   4. The lambda list has at least one &AUX parameter.
;;;;
;;;; The body (including the declarations) of the form that has the
;;;; lambda list is wrapped in a LET* form.  The LET* form has a
;;;; binding corresponding to the lambda-list parameters as described
;;;; below.
;;;;
;;;; Every required parameter p is replaced by a new lexical variable,
;;;; say l, and the LET* form is given a binding (p l).
;;;;
;;;; Every &OPTIONAL parameter of the form p or (p) is replaced by (l1
;;;; NIL l2) where l1 and l2 are new lexical variables, and the LET*
;;;; form is given a binding (p (IF l2 l1 NIL)).
;;;;
;;;; Every &OPTIONAL parameter of the form (p <form>) is replaced by
;;;; (l1 NIL l2) where l1 and l2 are new lexical variables, and the
;;;; LET* form is given a binding (p (IF l2 l1 <form>)).
;;;;
;;;; Every &OPTIONAL parameter of the form (p <form> s) is replaced by
;;;; (l1 NIL l2) where l1 and l2 are new lexical variables, and the
;;;; LET* form is given bindings (p (IF l2 l1 <form>)) and (s l2).
;;;;
;;;; Every &KEY parameter of the form p or (p) is replaced by ((:p l1)
;;;; NIL l2) where l1 and l2 are new lexical variables, and the LET*
;;;; form is given a binding (p (IF l2 l1 NIL)).
;;;;
;;;; Every &KEY parameter of the form ((k p)) is replaced by ((k l1)
;;;; NIL l2) where l1 and l2 are new lexical variables, and the LET*
;;;; form is given a binding (p (IF l2 l1 NIL)).
;;;;
;;;; Every &KEY parameter of the form (p <form>) is replaced by ((:p
;;;; l1) NIL l2) where l1 and l2 are new lexical variables, and the
;;;; LET* form is given a binding (p (IF l2 l1 <form>)).
;;;;
;;;; Every &KEY parameter of the form ((k p) <form>) is replaced by
;;;; ((k l1) NIL l2) where l1 and l2 are new lexical variables, and
;;;; the LET* form is given a binding (p (IF l2 l1 <form>)).
;;;;
;;;; Every &KEY parameter of the form (p <form> s) is replaced by ((:p
;;;; l1) NIL l2) where l1 and l2 are new lexical variables, and the
;;;; LET* form is given bindings (p (IF l2 l1 <form>)) and (s l2).
;;;;
;;;; Every &KEY parameter of the form ((k p) <form> s) is replaced by
;;;; ((k l1) NIL l2) where l1 and l2 are new lexical variables, and
;;;; the LET* form is given bindings (p (IF l2 l1 <form>)) and (s l2).
;;;;
;;;; Every &AUX parameter of the form p or (p) is removed, and the
;;;; LET* form is given a binding (p NIL).
;;;;
;;;; Every &AUX parameter of the form (p <form>) removed, and the
;;;; LET* form is given a binding (p <form>).


(defclass lexify-lambda-list-client (client) ())

(defun required-parameter-ast-lexified-p (ast)
  (typep (ico:name-ast ast) 'ico:variable-definition-ast))

(defun required-section-lexified-p (required-section-ast)
  (or
    (null required-section-ast)
    (loop for parameter-ast in (ico:parameter-asts required-section-ast)
          always (required-parameter-ast-lexified-p parameter-ast))))
          
(defun optional-or-key-parameter-ast-lexified-p (ast)
  (let ((parameter-ast (ico:parameter-ast ast))
        (supplied-p-parameter-ast (ico:supplied-p-parameter-ast ast))
        (init-form-ast (ico:init-form-ast ast)))
    (and
      (typep (ico:name-ast parameter-ast) 'ico:variable-definition-ast)
      (or
        (null init-form-ast)
        (and
          (typep init-form-ast 'ico:literal-ast)
          (null (ico:literal init-form-ast))))
      (not (null supplied-p-parameter-ast))
      (typep supplied-p-parameter-ast 'ico:variable-definition-ast))))

(defun optional-section-lexified-p (optional-section-ast)
  (or
    (null optional-section-ast)
    (loop for ast in (ico:parameter-asts optional-section-ast)
          always (optional-or-key-parameter-ast-lexified-p ast))))

(defun rest-section-lexified-p (rest-section-ast)
  (or
    (null rest-section-ast)
    (typep (ico:parameter-ast rest-section-ast)
           'ico:variable-definition-ast)))

(defun key-section-lexified-p (key-section-ast)
  (or
    (null key-section-ast)
    (loop for ast in (ico:parameter-asts key-section-ast)
          always (optional-or-key-parameter-ast-lexified-p ast))))

(defun aux-section-lexified-p (aux-section-ast)
  (or
    (null aux-section-ast)
    (null (ico:parameter-asts aux-section-ast))))

(defun lambda-list-lexified-p (lambda-list-ast)
  (and
    (required-section-lexified-p (ico:required-section-ast lambda-list-ast))
    (optional-section-lexified-p (ico:optional-section-ast lambda-list-ast))
    (rest-section-lexified-p (ico:rest-section-ast lambda-list-ast))
    (key-section-lexified-p (ico:key-section-ast lambda-list-ast))
    (aux-section-lexified-p (ico:aux-section-ast lambda-list-ast))))

(defun lexify-required-parameter-ast (required-parameter-ast)
  (let ((existing-name-ast (ico:name-ast required-parameter-ast)))
    (multiple-value-bind (definition-ast reference-ast)
        (create-lexical-variable-pair)
      (reinitialize-instance required-parameter-ast
        :name-ast definition-ast)
      (make-instance 'ico:variable-binding-ast
        :variable-name-ast existing-name-ast
        :form-ast reference-ast))))

(defun lexify-required-section-ast (required-section-ast)
  (loop for parameter-ast in (ico:parameter-asts required-section-ast)
        collect (lexify-required-parameter-ast parameter-ast)))

(defun lexify-optional-parameter-ast (optional-parameter-ast)
  (let* ((existing-parameter-ast (ico:parameter-ast optional-parameter-ast))
         (existing-name-ast (ico:name-ast existing-parameter-ast))
         (init-form-ast (ico:init-form-ast optional-parameter-ast))
         (existing-supplied-p-ast
           (ico:supplied-p-parameter-ast optional-parameter-ast))
         (existing-supplied-p-name-ast
           (if (null existing-supplied-p-ast)
               nil
               (ico:name-ast existing-supplied-p-ast))))
    (multiple-value-bind (definition-1-ast reference-1-ast)
        (create-lexical-variable-pair)
      (multiple-value-bind (definition-2-ast reference-2-ast)
          (create-lexical-variable-pair)
        (reinitialize-instance existing-parameter-ast
          :name-ast definition-1-ast)
        (reinitialize-instance optional-parameter-ast
          :init-form-ast (make-instance 'ico:literal-ast :literal 'nil))
        (reinitialize-instance existing-supplied-p-ast
          :name-ast definition-2-ast)
        (list* (list existing-name-ast
                     (make-instance 'ico:if-ast
                       :test-ast reference-2-ast
                       :then-ast reference-1-ast
                       :else-ast
                       (if (null init-form-ast)
                           (make-instance 'ico:literal-ast :literal 'nil)
                           init-form-ast)))
               (if (null existing-supplied-p-ast)
                   '()
                   (list (list existing-supplied-p-name-ast
                               reference-2-ast))))))))

(defun create-lexical-variable-pair ()
  (let* ((definition (make-instance 'ico:variable-definition-ast
                       :name (gensym)))
         (reference (make-instance 'ico:variable-reference-ast
                      :variable-definition-ast definition)))
    (reinitialize-instance definition
      :variable-reference-asts (list reference))
    (values definition reference)))

(defun ensure-lambda-list-lexified (ast)
  nil)

(defmethod cbaw:walk-ast-node :around
    ((client lexify-lambda-list-client) (ast ico:application-ast))
  ;; Start by converting any children of this AST node.
  (call-next-method)
  (let ((operator-ast (ico:function-name-ast ast)))
    (when (typep operator-ast 'ico:lambda-expression-ast)
      (ensure-lambda-list-lexified operator-ast)))
  ast)

(defmethod cbaw:walk-ast-node :around
    ((client lexify-lambda-list-client) (ast ico:flet-ast))
  ;; Start by converting any children of this AST node.
  (call-next-method)
  (loop for local-function-ast in (ico:binding-asts ast)
        do (ensure-lambda-list-lexified local-function-ast))
  ast)

(defmethod cbaw:walk-ast-node :around
    ((client lexify-lambda-list-client) (ast ico:labels-ast))
  ;; Start by converting any children of this AST node.
  (call-next-method)
  (loop for local-function-ast in (ico:binding-asts ast)
        do (ensure-lambda-list-lexified local-function-ast))
  ast)

(defmethod cbaw:walk-ast-node :around
    ((client lexify-lambda-list-client) (ast ico:application-ast))
  ;; Start by converting any children of this AST node.
  (call-next-method)
  (let ((operator-ast (ico:function-name-ast ast)))
    (when (typep operator-ast 'ico:lambda-expression-ast)
      (ensure-lambda-list-lexified operator-ast)))
  ast)
                  
(defun lexify-lambda-list (ast)
  (let ((client (make-instance 'lexify-lambda-list-client)))
    (cbaw:walk-ast client ast)))
