(cl:in-package #:common-boot-test)

(defmacro with-default-parameters
    ((client-variable environment-variable global-environment-variable)
     &body body)
  `(let* ((,client-variable (make-instance 'trucler-reference:client))
          (,environment-variable (cb:create-environment))
          (,global-environment-variable
            (trucler:global-environment
             ,client-variable ,environment-variable)))
     ,@body))
