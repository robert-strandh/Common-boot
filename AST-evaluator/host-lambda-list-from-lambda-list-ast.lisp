(cl:in-package #:common-boot-ast-evaluator)

(defgeneric host-parameter-from-parameter-ast (parameter-ast))

(defmethod host-parameter-from-parameter-ast
    ((ast ico:required-parameter-ast))
  (lookup (ico:name-ast ast)))

(defmethod host-parameter-from-parameter-ast
    ((ast ico:optional-parameter-ast))
  (let* ((parameter-ast (ico:parameter-ast ast))
         (parameter-name (lookup parameter-ast))
         (supplied-p-parameter-ast (ico:supplied-p-parameter-ast ast)))
    (if (null supplied-p-parameter-ast)
        parameter-name
        (list parameter-name
              nil
              (lookup supplied-p-parameter-ast)))))

(defmethod host-parameter-from-parameter-ast
    ((ast ico:rest-parameter-ast))
  (lookup (ico:name-ast ast)))

(defmethod host-parameter-from-parameter-ast
    ((ast ico:key-parameter-ast))
  (let* ((parameter-ast (ico:parameter-ast ast))
         (parameter-name (lookup parameter-ast))
         (keyword-ast (ico:keyword-ast ast))
         (keyword-name (ico:name keyword-ast))
         (supplied-p-parameter-ast (ico:supplied-p-parameter-ast ast)))
    (if (null supplied-p-parameter-ast)
        (list (list keyword-name parameter-name))
        (list (list keyword-name parameter-name)
              nil
              (lookup supplied-p-parameter-ast)))))

(defgeneric host-section-from-section-ast (section-ast))

(defmethod host-section-from-section-ast ((ast null))
  '())
  
(defmethod host-section-from-section-ast
    ((ast ico:required-section-ast))
  (loop for parameter-ast in (ico:parameter-asts ast)
        collect
        (host-parameter-from-parameter-ast parameter-ast)))
  
(defmethod host-section-from-section-ast
    ((ast ico:optional-section-ast))
  (cons '&optional
        (loop for parameter-ast in (ico:parameter-asts ast)
              collect (host-parameter-from-parameter-ast
                       parameter-ast))))
  
(defmethod host-section-from-section-ast
    ((ast ico:key-section-ast))
  (cons '&key
        (loop for parameter-ast in (ico:parameter-asts ast)
              collect (host-parameter-from-parameter-ast
                       parameter-ast))))

(defmethod host-section-from-section-ast
    ((ast ico:rest-section-ast))
  (list (host-parameter-from-parameter-ast (ico:parameter-ast ast))))

(defun host-lambda-list-from-lambda-list-ast (ast)
  (loop for accessor in (list #'ico:required-section-ast
                              #'ico:optional-section-ast
                              #'ico:rest-section-ast
                              #'ico:key-section-ast)
        append (host-section-from-section-ast
                (funcall accessor ast))))
