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
  (setf (clostrum:fdefinition client global-environment name)
        (fdefinition name)))

(defclass cps-function (closer-mop:funcallable-standard-object)
  ((%cps-entry-point :initarg :cps-entry-point :reader cps-entry-point))
  (:metaclass closer-mop:funcallable-standard-class))

(defmacro xlambda (lambda-list &body body)
  `(let* ((cps-entry-point (lambda ,lambda-list ,@body))
          (result (make-instance 'cps-function
                    :cps-entry-point cps-entry-point)))
     (closer-mop:set-funcallable-instance-function result cps-entry-point)
     result))

(defclass continuation (closer-mop:funcallable-standard-object)
  ((%origin :initarg :origin :reader origin)
   (%next-continuation :initarg :next-continuation :reader next-continuation))
  (:metaclass closer-mop:funcallable-standard-class))

(defun make-continuation (function &key origin next)
  (let ((result (make-instance 'continuation
                  :origin origin
                  :next-continuation next)))
    (closer-mop:set-funcallable-instance-function result function)
    result))
