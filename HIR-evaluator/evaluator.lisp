(cl:in-package #:common-boot-hir-evaluator)

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

;; A hash table, caching the thunk of each instruction that has
;; already been converted.
(defvar *instruction-thunks*)

;; The main entry point for converting instructions to thunks.
(defgeneric ensure-thunk (client instruction lexical-environment))

(defmethod ensure-thunk :around
    (client instruction lexical-environment)
  (multiple-value-bind (thunk presentp)
      (gethash instruction *instruction-thunks*)
    (if presentp thunk (call-next-method))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Representing top-level HIR as a host functions.
;;;
;;; The top-level HIR function is not subject to argument processing,
;;; because we completely control how it is called.  Instead, we just
;;; pass it a single required parameter, namely a vector to be filled
;;; in with values of LOAD-TIME-VALUE forms and constants created by
;;; the reader.  The parameter LEXICAL-LOCATION is the third output of
;;; the PARSE-ARGUMENTS-INSTRUCTION.  (FIXME: should we access it as
;;; the first element of the lambda list instead?)

(defun top-level-hir-to-host-function (client parse-arguments-instruction)
  (let* ((*instruction-thunks* (make-hash-table :test #'eq))
         (lexical-environment (make-lexical-environment))
         (successor
           (first (hir:successors parse-arguments-instruction)))
         (thunk
           (ensure-thunk client successor lexical-environment)))
    (lambda ()
      (let ((lexical-locations (make-lexical-locations lexical-environment))
            (thunk thunk))
        (catch 'return
          (loop (catch 'unwind
                  (loop (setf thunk
                              (funcall thunk
                                       lexical-locations))))))))))
