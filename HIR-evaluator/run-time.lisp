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
  ((%unique-identity
    :initarg :unique-identity
    :reader unique-identity)
   (%unwind-tag
    :initarg :unwind-tag
    :reader unwind-tag)))

(defun unwind
    (successor dynamic-environment unique-identity &optional values)
  (let ((entry (find unique-identity dynamic-environment
                     :key #'unique-identity :test #'eq)))
    (assert (not (null entry)))
    (setf *unwind-values* values)
    (throw (unwind-tag entry) successor)))

(defclass special-variable-bind-entry ()
  ((%name
    :initarg :name
    :reader name)
   (%value
    :initarg :value
    :accessor value)))

;;; This variable contains the values transmitted by the UNWIND
;;; instruction.
(defvar *unwind-values*)

(defun symbol-value
    (name cell &optional (dynamic-environment *dynamic-environment*))
  (loop for entry in dynamic-environment
        do (when (and (typep entry 'special-variable-bind-entry)
                      (eq name (name entry)))
             (if (slot-boundp entry '%value)
                 (return (value entry))
                 (error "unbound variable ~s" name)))
        finally (if (eq (car cell) (cdr cell))
                    (error "unbound variable ~s" name)
                    (return (car cell)))))

(defun (setf symbol-value)
    (value name cell &optional (dynamic-environment *dynamic-environment*))
  (loop for entry in dynamic-environment
        do (when (and (typep entry 'special-variable-bind-entry)
                      (eq name (name entry)))
             (setf (value entry) value)
             (return value))
        finally (return (setf (car cell) value))))

(defclass catch-entry ()
  ((%unwind-tag
    :initarg :unwind-tag
    :reader unwind-tag)
   (%catch-tag
    :initarg :catch-tag
    :reader catch-tag)
   (%successor
    :initarg :successor
    :reader successor)))
