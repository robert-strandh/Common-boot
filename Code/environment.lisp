(cl:in-package #:common-boot)

(defclass environment (clb:run-time-environment)
  ())

(defun create-environment ()
  (let ((environment (make-instance 'environment))
        (cl-package (find-package '#:common-lisp)))
    (loop with cmd = (find-package '#:common-macro-definitions)
          for symbol being each external-symbol in cmd
          for symbol-name = (symbol-name symbol)
          for cl-symbol = (find-symbol symbol-name cl-package)
          for macro-function = (macro-function symbol)
          do (unless (null macro-function)
               (setf (clo:macro-function nil environment cl-symbol)
                     macro-function)))
    (make-instance 'trucler-reference:environment
      :global-environment environment)))
