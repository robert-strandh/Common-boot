(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps
    (client environment (ast ico:multiple-value-call-ast) continuation)
  (let* ((values-temp (make-symbol "VALUES"))
         (function-temp (make-symbol "FUNCTION"))
         (arguments-temp (make-symbol "ARGUMENTS"))
         (continuation-variable (gensym "C-"))
         (action `(progn (setf arguments
                               (multiple-value-list
                                (apply ,function-temp
                                       ,arguments-temp)))
                         (setf continuation ,continuation))))
    (loop for form-ast in (reverse (ico:form-asts ast))
          do (setf action
                   `(let ((,continuation-variable
                            (lambda (&rest ,values-temp)
                              (setf ,arguments-temp
                                    (append ,arguments-temp ,values-temp))
                              ,action)))
                      ,(cps client environment form-ast continuation-variable))))
    `(let ((,continuation-variable
             (lambda (&rest ,function-temp)
               (setf ,function-temp (car ,function-temp))
               (let ((,arguments-temp '()))
                 ,action))))
       ,(cps client environment (ico:function-ast ast) continuation-variable))))
    
