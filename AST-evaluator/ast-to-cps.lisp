(cl:in-package #:common-boot-ast-evaluator)

(defun ast-to-cps (client ast)
  (let ((variable (gensym))
        (environment (make-hash-table :test #'eq)))
    `(lambda ()
       ,(cps client ast environment
             `(lambda (&rest ,variable)
                (declare (ignore ,variable))
                ,(pop-stack client))))))
