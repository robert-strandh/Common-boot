(cl:in-package #:common-boot-ast-evaluator)

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

(defclass continuation-entry-mixin ()
  ((%continuation
    :initarg :continuation
    :reader continuation)))

(defclass catch-tag-mixin ()
  ((%catch-tag
    :initarg :catch-tag
    :reader catch-tag)))

(defclass block-entry
    (dynamic-environment-entry
     continuation-entry-mixin
     catch-tag-mixin
     valid-p-mixin)
  ((%name :initarg :name :reader name)))

(defmethod print-object ((object block-entry) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "name: ~s valid-p: ~s"
            (name object) (valid-p object))))

(defclass unwind-protect-entry (dynamic-environment-entry)
  ((%closure :initarg :closure :reader closure)))

;;; This variable is used only to pass the continuation over a
;;; function call.  The caller assigns the current continuation to it,
;;; and the callee initializes its own lexical variable holding the
;;; continuatino to its value.
(defparameter *continuation* '())

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

(defclass tag-entry (continuation-entry-mixin catch-tag-mixin)
  ((%name :initarg :name :reader name)))

(defmethod print-object ((object tag-entry) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "name: ~s" (name object))))

(defclass tagbody-entry
    (dynamic-environment-entry valid-p-mixin)
  ((%tag-entries :initarg :tag-entries :initform '() :reader tag-entries)))

(defmethod print-object ((object tagbody-entry) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "valid-p: ~s tag-entries ~s"
            (valid-p object) (tag-entries object))))

(defun tagbody-entry-predicate (name)
  (lambda (entry)
    (and (typep entry 'tagbody-entry)
      (member-if (lambda (e) (eq (name e) name))
                 (tag-entries entry)))))

(defun do-go (name dynamic-environment)
  (let ((entry (find-if (tagbody-entry-predicate name) dynamic-environment)))
    (cond ((null entry)
           (error "No valid TAG entry for ~s" name))
          ((not (valid-p entry))
           ;; For now, signal a host error.  It would be better to
           ;; call the target function ERROR.
           (error "Attempt to use an expired entry ~s~%" entry))
          (t
           (unwind entry dynamic-environment nil)
           (find-if (lambda (e) (eq (name e) name))
                    (tag-entries entry))))))

(defclass catch-entry
    (dynamic-environment-entry continuation-entry-mixin valid-p-mixin)
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

(defmacro step (arguments continuation)
  (let ((a (gensym))
        (c (gensym)))
    `(let ((,a ,arguments)
           (,c ,continuation))
       (setf arguments ,a
             continuation ,c)
       (when (typep ,c 'after-continuation)
         (setf (results ,c) ,a)))))

(defun boundp
    (name cell &optional (dynamic-environment *dynamic-environment*))
  (loop for entry in dynamic-environment
        do (when (and (typep entry 'special-variable-entry)
                      (eq name (name entry)))
             (return (slot-boundp entry '%value)))
        finally (return (not (eq (car cell) (cdr cell))))))

(defun symbol-value
    (name cell &optional (dynamic-environment *dynamic-environment*))
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
  (loop for entry in dynamic-environment
        do (when (and (typep entry 'special-variable-entry)
                      (eq name (name entry)))
             (setf (value entry) value)
             (return value))
        finally (return (setf (car cell) value))))

(defclass continuation (closer-mop:funcallable-standard-object)
  ((%origin :initarg :origin :reader origin)
   (%next-continuation
    :initarg :next-continuation
    :accessor next-continuation))
  (:metaclass closer-mop:funcallable-standard-class))

(defclass before-continuation (continuation)
  ()
  (:metaclass closer-mop:funcallable-standard-class))

(defclass after-continuation (continuation)
  ((%results
    :initform nil
    :initarg :results
    :accessor results)
   (%results-valid-p
    :initform nil
    :initarg :results-valid-p
    :accessor results-valid-p))
  (:metaclass closer-mop:funcallable-standard-class))

(defmethod (setf results) :after
    (results (continuation after-continuation))
  (setf (results-valid-p continuation) t))

(defun make-before-continuation (function &key origin next)
  (let ((result (make-instance 'before-continuation
                  :origin origin
                  :next-continuation next)))
    (closer-mop:set-funcallable-instance-function result function)
    result))

(defun make-after-continuation (function &key origin next)
  (let ((result (make-instance 'after-continuation
                  :origin origin
                  :next-continuation next)))
    (closer-mop:set-funcallable-instance-function result function)
    result))

(defparameter *debug-trampoline-iterations* nil)

(defgeneric maybe-print-continuation (continuation))

(defmethod maybe-print-continuation :around (continuation)
  (when (typep (origin continuation) 'cst:cst)
    (format *debug-io* "----------------------~%")
    (call-next-method)))

(defmethod maybe-print-continuation ((continuation continuation))
  (let ((origin (origin continuation)))
    (format *debug-io*
            "Origin: ~s~%"
            (if (null (cst:source origin))
                (cst:raw origin)
                (cst:source origin)))))
          
(defmethod maybe-print-continuation :after
    ((continuation after-continuation))
  (format *debug-io* "After~%")
  (when (results-valid-p continuation)
    (format *debug-io*
            "Values: ~s~%"
            (results continuation))))

(defun trampoline-iteration (continuation dynamic-environment)
  (when *debug-trampoline-iterations*
    (format *debug-io* "=======================~%")
    (loop for c = continuation then (next-continuation c)
          until (null c)
          do (maybe-print-continuation c))
    (format *debug-io* ".......................~%")
    (loop for entry in dynamic-environment
          do (format *debug-io* "~s~%" entry))
    (format *debug-io* ".......................~%")
    (read *debug-io*)))

(defmacro trampoline-loop ()
  `(loop (progn (trampoline-iteration continuation dynamic-environment)
                (apply continuation arguments))))

;;; This table can be used to count origins in APPLY-WITH-ORIGIN.
(defparameter *ht* (make-hash-table :test #'eq))

(defun apply-with-origin (function arguments origin)
  (let* ((entry (make-instance 'cb:stack-entry
                  :origin origin
                  :called-function function
                  :arguments arguments))
         (cb:*stack* (cons entry cb:*stack*)))
    (apply function arguments)
    #+(or)(if (null origin)
              (apply function arguments)
              (let ((value (gethash origin *ht*))
                    (start-time (get-universal-time)))
                (when (null value)
                  (setf value (cons 0 0))
                  (setf (gethash origin *ht*) value))
                (multiple-value-prog1 (apply function arguments)
                  (incf (car value))
                  (incf (cdr value) (- (get-universal-time) start-time)))))))
