(cl:in-package #:common-boot-hir-evaluator)

;;; This variable contains a catch tag to be used by the
;;; EXIT-POINT-INSTRUCTION to create an entry in the dynamic
;;; environment.  The UNWIND instruction then does a host CATCH to
;;; this tag.
(defvar *unwind-tag*)

;;; A hash table, caching the thunk of each instruction that has
;;; already been converted.
(defvar *instruction-thunks*)

;;; The main entry point for converting instructions to thunks.
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
;;; the reader.

(defun top-level-hir-to-host-function (client initial-instruction)
  (let* ((*instruction-thunks* (make-hash-table :test #'eq))
         (*unwind-tag* 'invalid)
         (lexical-environment (make-lexical-environment))
         (thunk
           (ensure-thunk client initial-instruction lexical-environment)))
    (lambda ()
      (let ((lexical-locations (make-lexical-locations lexical-environment))
            (thunk thunk))
        (catch 'return
          (loop (catch 'unwind
                  (loop (setf thunk
                              (funcall thunk
                                       lexical-locations))))))))))
