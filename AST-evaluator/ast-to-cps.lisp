(cl:in-package #:common-boot-ast-evaluator)

(defun ast-to-cps (client ast)
  (let ((variable (gensym)))
    `(lambda ()
       ,(cps
         client
         ast
         `(lambda (&rest ,variable)
            (declare (ignore ,variable))
            ,(pop-stack client))))))
