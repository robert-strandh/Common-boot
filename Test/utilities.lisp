(cl:in-package #:common-boot-test)

(defmacro with-default-parameters
    ((client-variable environment-variable global-environment-variable)
     &body body)
  `(let* ((,client-variable (make-instance 'trucler-reference:client))
          (,environment-variable (cb:create-environment))
          (,global-environment-variable
            (trucler:global-environment
             ,client-variable ,environment-variable)))
     (declare (ignorable ,global-environment-variable))
     ,@body))

(defmacro iss (form1 form2)
  `(is #'equal
       (multiple-value-list ,form1)
       (multiple-value-list ,form2)))

(defun eval-expression (expression environment)
  (cb:eval-expression expression environment))
