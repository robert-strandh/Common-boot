(cl:in-package #:common-boot-ast-evaluator)

(defun ast-to-cps (client ast)
  (let ((variable (gensym))
        (environment (make-hash-table :test #'eq)))
    `(lambda (client environment)
       (declare (ignorable client environment))
       ,(cps client ast environment
             `(lambda (&rest ,variable)
                (declare (ignore ,variable))
                ,(pop-stack-operation client))))))
