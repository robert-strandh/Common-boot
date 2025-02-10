(cl:in-package #:common-boot-ast-to-abstract-machine)

(defvar *register-numbers*)

(defvar *dynamic-environment-register*)

(defclass context ()
  ((%next-instructions
    :initarg :next-instructions
    :reader next-instructions)
   ;; This slot contains 0, 1, or :ALL.
   (%values-count
    :initarg :values-count
    :reader values-count)
   (%target-register
    :initarg :target-register
    :reader target-register)))

(defun make-context (next-instructions values-count target-register)
  (make-instance 'context
    :next-instructions next-instructions
    :values-count values-count
    :target-register target-register))

(defmacro with-context-components ((context-form) &body body)
  (let ((context-variable (gensym)))
    `(let* ((,context-variable ,context-form)
            (next-instructions (next-instructions ,context-variable))
            (values-count (values-count ,context-variable))
            (target-register (target-register ,context-variable)))
       ,@body)))

(defmacro with-new-register ((identity register-variable) &body body)
  `(let* ((,register-variable (1+ (cdar *register-numbers*)))
          (*register-numbers*
            (acons ,identity ,register-variable *register-numbers*)))
     ,@body))

(defmacro with-new-registers ((identities registers-variable) &body body)
  `(let* ((,registers-variable
            (loop for register-number from (1+ (cdar *register-numbers*))
                  repeat (length ,identities)
                  collect register-number))
          (*register-numbers*
            (append (pairlis ,identities ,registers-variable)
                    *register-numbers*)))
     ,@body))

(defun find-register (variable-reference-ast)
  (let* ((definition-ast (ico:definition-ast variable-reference-ast))
         (result (assoc definition-ast *register-numbers*)))
    (assert (not (null result)))
    result))
