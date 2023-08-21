(cl:in-package #:common-boot-ast-evaluator)

;;; During CPS creation, this variable holds a hash table that maps
;;; target objects such as variables and tags to host names.
(defvar *host-names*)

(defun lookup (ast)
  (gethash ast *host-names*))

(defun (setf lookup) (value ast)
  (setf (gethash ast *host-names*) value))

(defun import-host-function (client name global-environment)
  (let ((host-function (fdefinition name)))
    (setf (clostrum:fdefinition client global-environment name)
          (lambda (&rest arguments)
            (setf *arguments*
                  (multiple-value-list (apply host-function arguments)))
            (pop-stack)))))
