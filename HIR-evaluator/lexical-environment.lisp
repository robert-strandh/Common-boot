(cl:in-package #:common-boot-hir-evaluator)

;;; A lexical environment is an object we use while converting
;;; instructions to thunks.  It is used to assign each lexical
;;; location a suitable index into a vector, and to create such a
;;; vector in the first place.

(defclass lexical-environment ()
  (;; A hash table mapping from lexical locations to the corresponding
   ;; index in the vector of lexical locations.
   (%indices
    :initform (make-hash-table :test #'eq)
    :reader indices
    :type hash-table)
   ;; A counter tracking the length of the list of contents.
   (%counter
    :initform 0
    :accessor counter
    :type unsigned-byte)
   ;; A reversed list of the initial contents of the lexical
   ;; environment.
   (%contents
    :initform '()
    :accessor contents
    :type list)))

(defun make-lexical-environment ()
  (make-instance 'lexical-environment))

(declaim (inline lexical-value))
(defun lexical-value (lexical-locations lexical-reference)
  (declare (simple-vector lexical-locations)
           (fixnum lexical-reference))
  (let ((result (svref lexical-locations lexical-reference)))
    (assert (not (eq result '.unbound.)))
    result))

(declaim (inline (setf lexical-value)))
(defun (setf lexical-value) (value lexical-locations lexical-reference)
  (declare (simple-vector lexical-locations)
           (fixnum lexical-reference))
  (assert (not (eq value '.unbound.)))
  (setf (svref lexical-locations lexical-reference)
        value))

(defun make-lexical-locations (lexical-environment)
  (with-accessors ((counter counter)
                   (contents contents))
      lexical-environment
    (let ((vector (make-array counter)))
      (loop for element in contents
            for index downfrom (1- counter)
            do (setf (svref vector index) element))
      vector)))

(defun insert-lexical-reference (entity lexical-environment)
  (with-accessors ((indices indices)
                   (counter counter)
                   (contents contents))
      lexical-environment
    (prog1 counter
      (setf (gethash entity indices)
            counter)
      (incf counter)
      (push (if (typep entity 'hir:literal)
                (hir:value entity)
                '.unbound.)
            contents))))

(defun ensure-lexical-reference (entity lexical-environment)
  (with-accessors ((indices indices))
      lexical-environment
    (multiple-value-bind (index presentp)
        (gethash entity indices)
      (if presentp
          index
          (insert-lexical-reference entity lexical-environment)))))
