(cl:in-package #:common-boot-fast-ast-evaluator)

(defclass closure (closer-mop:funcallable-standard-object)
  ((%static-environment
    :initform nil
    :accessor static-environment)
   (%function
    :initarg :function
    :reader function)
   (%lambda-list-ast
    :initarg :lambda-list-ast
    :reader lambda-list-ast)
   (%form-asts
    :initarg :form-asts
    :reader form-asts))
  (:metaclass closer-mop:funcallable-standard-class))

(defmacro make-closure
    (closure-name code-object-name lambda-list-ast form-asts)
  `(make-instance 'closure
     :function ,code-object-name
     :lambda-list-ast ,lambda-list-ast
     :form-asts ',form-asts))

(defmacro set-function (closure-name code-object-name)
  `(closer-mop:set-funcallable-instance-function
    ,closure-name
    (lambda (&rest arguments)
      (let ((*static-environment*
              (static-environment ,closure-name)))
        (declare (special *static-environment*))
        (apply ,code-object-name arguments)))))

(defun make-closure-binding (function-ast)
  (let* ((name-ast (ico:name-ast function-ast))
         (lambda-list-ast (ico:lambda-list-ast function-ast))
         (form-asts (ico:form-asts function-ast))
         (code-object-name (gethash name-ast *code-object-names*))
         (closure-name (gensym)))
    (setf (lookup name-ast) closure-name)
    `(,closure-name
      (let ((,closure-name
              (make-closure ,closure-name
                            ,code-object-name
                            ,lambda-list-ast
                            ,form-asts)))
        (set-function ,closure-name ,code-object-name)
        ,closure-name))))

(defmethod translate-ast (client (ast ico:labels-ast))
  `(let ,(loop for function-ast in (ico:binding-asts ast)
               collect (make-closure-binding function-ast))
     ,@(translate-implicit-progn client (ico:form-asts ast))))
