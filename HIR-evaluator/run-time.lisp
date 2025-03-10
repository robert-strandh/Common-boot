(cl:in-package #:common-boot-hir-evaluator)

(defvar *static-environment*)

(defun enclose (entry-point)
  (let ((closure (make-instance 'closure)))
    (closer-mop:set-funcallable-instance-function
     closure
     (lambda (&rest arguments)
       (let ((*static-environment* (static-environment closure)))
         (apply entry-point arguments))))
    closure))

(defparameter *call-stack-depth* 0)

(defmacro with-new-call-stack-entry (entry &body body)
  `(let ((cb:*stack* (cons ,entry cb:*stack*)))
     (when (> *call-stack-depth* 200)
       (error "Call stack exhausted"))
     (incf *call-stack-depth*)
     (unwind-protect (progn ,@body)
       (decf *call-stack-depth*))))

(defparameter *dynamic-environment* '())

(defclass exit-point-entry ()
  ((%unique-identity
    :initarg :unique-identity
    :reader unique-identity)
   (%unwind-tag
    :initarg :unwind-tag
    :reader unwind-tag)))

;;; This variable contains the values transmitted by the UNWIND
;;; instruction.
(defvar *unwind-values*)

(defun unwind
    (successor dynamic-environment unique-identity &optional values)
  (let ((entry (find-if (lambda (entry)
                          (and (typep entry 'exit-point-entry)
                               (eq unique-identity
                                   (unique-identity entry))))
                        dynamic-environment)))
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

(defun proper-list-p (object)
  (numberp (ignore-errors (list-length object))))

(defun boundp
    (name cell &optional (dynamic-environment *dynamic-environment*))
  (assert (proper-list-p dynamic-environment))
  (loop for entry in dynamic-environment
        do (when (and (typep entry 'special-variable-bind-entry)
                      (eq name (name entry)))
             (return (slot-boundp entry '%value)))
        finally (return (not (eq (car cell) (cdr cell))))))

(defun symbol-value
    (name cell &optional (dynamic-environment *dynamic-environment*))
  (assert (proper-list-p dynamic-environment))
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
  (assert (proper-list-p dynamic-environment))
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

(defun throw-unwind (dynamic-environment tag values)
  (let ((entry (find-if (lambda (entry)
                          (and (typep entry 'catch-entry)
                               (eq tag (catch-tag entry))))
                        dynamic-environment)))
    (assert (not (null entry)))
    (setf *unwind-values* values)
    (throw (unwind-tag entry) (successor entry))))
