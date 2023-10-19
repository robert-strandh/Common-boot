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
     (closer-mop:set-funcallable-instance-function
      result
      (lambda (&rest arguments)
        (block nil
          (setq *dynamic-environment* '())
          (setq *continuation*
                (lambda (&rest arguments)
                  (return (apply #'values arguments))))
          (push-stack)
          (setq *continuation* cps-entry-point)
          (setq *arguments* arguments)
          (loop (evaluator-step)))))
     result))

(defclass continuation (closer-mop:funcallable-standard-object)
  ((%origin :initarg :origin :reader origin)
   (%next-continuation :initarg :next-continuation :reader next-continuation))
  (:metaclass closer-mop:funcallable-standard-class))

(defmacro make-continuation ((ast next-continuation lambda-list) &body body)
  (let ((result-variable (gensym)))
    `(let ((,result-variable
             (make-instance 'continuation
               :origin (ico:origin ,ast)
               :next-continuation ,next-continuation)))
       (closer-mop:set-funcallable-instance-function
        ,result-variable
        (lambda ,lambda-list ,@body)))))
