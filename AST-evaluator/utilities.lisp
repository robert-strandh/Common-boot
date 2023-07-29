(cl:in-package #:common-boot-ast-evaluator)

(defun lookup (ast environment)
  (gethash ast environment))

(defun (setf lookup) (value ast environment)
  (setf (gethash ast environment) value))

(defun import-host-function (client name global-environment)
  (let ((host-function (fdefinition name)))
    (setf (clostrum:fdefinition client global-environment name)
          (lambda (&rest arguments)
            (setf *arguments*
                  (multiple-value-list (apply host-function arguments)))
            (pop-stack)))))
