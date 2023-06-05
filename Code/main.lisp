(cl:in-package #:common-boot)


(defun create-environment ()
  (let ((environment (make-instance 'clb:run-time-environment)))
    (loop with cmd = (find-package '#:common-macro-definitions)
          with cl-package = (find-package '#:common-lisp)
          for symbol being each external-symbol in cmd
          for symbol-name = (symbol-name symbol)
          for cl-symbol = (find-symbol symbol-name cl-package)
          do (setf (clo:macro-function nil environment cl-symbol)
                   (macro-function symbol)))
    environment))
