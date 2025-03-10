(cl:in-package #:common-boot-ast-interpreter)

(declaim (inline lookup))

(defun lookup (thing environment)
  (let ((entry (assoc thing environment :test #'eq)))
    (if (null entry)
        (error "No entry for ~s in environment ~s"
               thing environment)
        (cdr entry))))

(defclass dynamic-environment-entry ()
  ())

(defclass valid-p-mixin ()
  ((%valid-p
    :initform t
    :accessor valid-p)))

(defgeneric invalidate-entry (entry))

;;; The default method is invoked when ENTRY is not an instance of
;;; VALID-P-MIXIN.
(defmethod invalidate-entry (entry)
  nil)

(defmethod invalidate-entry ((entry valid-p-mixin))
  (setf (valid-p entry) nil))

(defclass unwinder-entry-mixin ()
  ((%unwinder
    :initarg :unwinder
    :reader unwinder)))

(defclass block-entry
    (dynamic-environment-entry
     unwinder-entry-mixin
     valid-p-mixin)
  ((%name :initarg :name :reader name)))

(defmethod print-object ((object block-entry) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "name: ~s valid-p: ~s"
            (name object) (valid-p object))))

(defclass unwind-protect-entry (dynamic-environment-entry)
  ((%closure :initarg :closure :reader closure)))

;;; This variable is used only to pass the dynamic environment over a
;;; function call.  The caller assigns the current dynamic environment
;;; to it, and the callee initializes its own lexical variable holding
;;; the dynamic environment to its value.
(defparameter *dynamic-environment* '())

;;; Unwind the dynamic environment up to, but not including ENTRY.
;;; ENTRY is invalidated by this function if and only if
;;; INVALIDATE-ENTRY-P is true.  So if this function is called as a
;;; result of a RETURN-FROM or a THROW, then INVALIDATE-ENTRY-P should
;;; be true, but if it is called as a result of a GO, then
;;; INVALIDATE-ENTRY-P should be false.
(defun unwind (entry dynamic-environment invalidate-entry-p)
  ;; Start by invalidating every entry before but not including ENTRY.
  (loop for entry-to-invalidate in dynamic-environment
        until (eq entry-to-invalidate entry)
        do (invalidate-entry entry-to-invalidate))
  ;; Then invalidate ENTRY if and only if INVALIDATE-ENTRY-P is true.
  (when invalidate-entry-p
    (invalidate-entry entry))
  ;; Unwind the dynamic environment by executing any UNWIND-PROTECT
  ;; that precedes ENTRY.
  (loop for tail on dynamic-environment
        for (maybe-unwind-protect-entry . rest) = tail
        until (eq maybe-unwind-protect-entry entry)
        when (typep maybe-unwind-protect-entry 'unwind-protect-entry)
          do ;; The closure in the UNWIND-PROTECT entry is an ordinary
             ;; function with no parameters, so it sets its private
             ;; variable DYNAMIC-ENVIRONMENT from
             ;; *DYNAMIC-ENVIRONMENT*.  We must therefore supply a
             ;; value for *DYNAMIC-ENVIRONMENT*.  We must supply a
             ;; dynamic environment that excludes the UNWIND-PROTECT
             ;; entry in case there is a non-local control transfer in
             ;; the UNWIND-PROTECT closure.
             (let ((*dynamic-environment* rest))
               (funcall (closure maybe-unwind-protect-entry)))))

(defun block-entry-predicate (name)
  (lambda (entry)
    (and (typep entry 'block-entry)
         (eq name (name entry)))))

(defun check-dynamic-environment (dynamic-environment)
  (loop for entry in dynamic-environment
        do (when (typep entry 'valid-p-mixin)
             (unless (valid-p entry)
               (error "invalid-entry: ~s" entry)))))

(defun do-return-from (name dynamic-environment)
  (let ((entry (find-if (block-entry-predicate name) dynamic-environment)))
    (cond ((null entry)
           (error "No valid BLOCK entry for ~s" name))
          ((not (valid-p entry))
           ;; For now, signal a host error.  It would be better to
           ;; call the target function ERROR.
           (error "Attempt to use an expired entry ~s~%" entry))
          (t 
           (unwind entry dynamic-environment t)
           entry))))

(defclass tag-entry (unwinder-entry-mixin)
  ((%name :initarg :name :reader name)))

(defmethod print-object ((object tag-entry) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "name: ~s" (name object))))

(defclass tagbody-entry
    (dynamic-environment-entry valid-p-mixin)
  ((%identity :initarg :identity :reader identity)
   (%unwinders :initarg :unwinders :reader unwinders)))

(defmethod print-object ((object tagbody-entry) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "identity: ~s valid-p: ~s unwinders ~s"
            (identity object) (valid-p object) (unwinders object))))

(defun tagbody-entry-predicate (identity)
  (lambda (entry)
    (and (typep entry 'tagbody-entry)
         (eq identity (identity entry)))))

(defun do-go (identity dynamic-environment)
  (let ((entry (find-if (tagbody-entry-predicate identity)
                        dynamic-environment)))
    (cond ((null entry)
           (error "No valid TAG entry for ~s" identity))
          ((not (valid-p entry))
           ;; For now, signal a host error.  It would be better to
           ;; call the target function ERROR.
           (error "Attempt to use an expired entry ~s~%" entry))
          (t
           (unwind entry dynamic-environment nil)
           entry))))

(defclass catch-entry
    (dynamic-environment-entry unwinder-entry-mixin valid-p-mixin)
  ((%name :initarg :name :reader name)))

(defun catch-entry-predicate (name)
  (lambda (entry)
    (and (typep entry 'catch-entry)
         (eq name (name entry)))))

(defun do-throw (name dynamic-environment)
  (let ((entry (find-if (catch-entry-predicate name) dynamic-environment)))
    (cond ((null entry)
           (error "No valid catch entry for ~s" name))
          ((not (valid-p entry))
           ;; For now, signal a host error.  It would be better to
           ;; call the target function ERROR.
           (error "Attempt to use an expired entry ~s~%" entry))
          (t
           (unwind entry dynamic-environment t)
           entry))))

(defclass special-variable-entry (dynamic-environment-entry)
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
        do (when (and (typep entry 'special-variable-entry)
                      (eq name (name entry)))
             (return (slot-boundp entry '%value)))
        finally (return (not (eq (car cell) (cdr cell))))))

(defun symbol-value
    (name cell &optional (dynamic-environment *dynamic-environment*))
  (assert (proper-list-p dynamic-environment))
  (loop for entry in dynamic-environment
        do (when (and (typep entry 'special-variable-entry)
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
        do (when (and (typep entry 'special-variable-entry)
                      (eq name (name entry)))
             (setf (value entry) value)
             (return value))
        finally (return (setf (car cell) value))))
