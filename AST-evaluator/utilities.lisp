(cl:in-package #:common-boot-ast-evaluator)

;;; During CPS creation, this variable holds a hash table that maps
;;; target objects such as variables and tags to host names.
(defvar *host-names*)

(defun lookup (ast)
  (multiple-value-bind (result presentp)
      (gethash ast *host-names*)
    (assert presentp)
    result))

(defun (setf lookup) (value ast)
  (setf (gethash ast *host-names*) value))

(defun import-host-function (client name global-environment)
  (let ((host-function (fdefinition name)))
    (setf (clostrum:fdefinition client global-environment name)
          (lambda (&rest arguments)
            (setf *arguments*
                  (multiple-value-list (apply host-function arguments)))
            (pop-stack)))))

(defclass cps-function (closer-mop:funcallable-standard-object)
  ()
  (:metaclass closer-mop:funcallable-standard-class))

(defmacro xlambda (lambda-list &body body)
  `(let ((result (make-instance 'cps-function)))
     (closer-mop:set-funcallable-instance-function
      result (lambda ,lambda-list ,@body))))
