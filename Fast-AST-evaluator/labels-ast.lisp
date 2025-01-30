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

(defmethod translate-ast (client environment (ast ico:labels-ast))
  `(let ,(loop for function-ast in (ico:binding-asts ast)
               for name-ast = (ico:name-ast function-ast)
               for lambda-list-ast = (ico:lambda-list-ast function-ast)
               for form-asts = (ico:form-asts function-ast)
               for name = (gethash name-ast *code-object-names*)
               collect `(,name
                         (make-instance 'closure
                           :static-environment *static-environment*
                           :function name
                           :lambda-list-ast lambda-list-ast
                           :form-asts form-asts)))
     ,@(translate-implicit-progn client environment (ico:form-asts ast))))
