(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps
    (client (ast ico:multiple-value-call-ast) environment continuation)
  (let* ((values-temp (make-symbol "VALUES"))
         (function-temp (make-symbol "FUNCTION"))
         (arguments-temp (make-symbol "ARGUMENTS"))
         (action `(progn (setf *continuation* ,continuation)
                         ,(push-stack-operation client)
                         (step ,arguments-temp
                                ,function-temp))))
    (loop for form-ast in (reverse (ico:form-asts ast))
          do (setf action
                   (cps client
                        form-ast
                        environment
                        `(lambda (&rest ,values-temp)
                           (setf ,arguments-temp
                                 (append ,arguments-temp ,values-temp))
                           ,action))))
    (cps client
         (ico:function-ast ast)
         environment
         `(lambda (&rest ,function-temp)
            (setf ,function-temp (car ,function-temp))
            (let ((,arguments-temp '()))
              ,action)))))

    
