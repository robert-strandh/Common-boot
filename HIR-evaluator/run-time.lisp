(cl:in-package #:common-boot-hir-evaluator)

(defun enclose (entry-point)
  (let ((closure (make-instance 'closure)))
    (closer-mop:set-funcallable-instance-function
     closure
     (lambda (&rest arguments)
       (let ((*static-environment* (static-environment closure)))
         (apply entry-point arguments))))
    closure))

;; A list of call stack entries.
(defparameter *call-stack* '())

(defparameter *call-stack-depth* 0)

(defmacro with-new-call-stack-entry (entry &body body)
  `(let ((*call-stack* (cons ,entry *call-stack*)))
     (when (> *call-stack-depth* 200)
       (error "Call stack exhausted"))
     (incf *call-stack-depth*)
     (unwind-protect (progn ,@body)
       (decf *call-stack-depth*))))

(defclass call-stack-entry ()
  ((%origin :initarg :origin :reader origin)
   (%arguments :initarg :arguments :reader arguments)))

(defvar *static-environment*)

(defvar *dynamic-environment*)

(defclass exit-point-entry ()
  ((%unique-identiry
    :initarg :unique-identiry
    :reader unique-identiry)
   (%catch-tag
    :initarg :catch-tag
    :reader catch-tag)))

(defclass special-variable-bind-entry ()
  ((%name
    :initarg :name
    :reader name)
   (%value
    :initarg :value
    :reader value)))

;;; This variable contains the values transmitted by the UNWIND
;;; instruction.
(defvar *unwind-values*)
