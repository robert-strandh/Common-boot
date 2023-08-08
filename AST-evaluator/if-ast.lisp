(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:if-ast) environment continuation)
  (let ((temp (gensym))
        (else-ast (if (null (ico:else-ast ast))
                      (make-instance 'ico:literal-ast :literal nil)
                      (ico:else-ast ast))))
    (cps client
         (ico:test-ast ast)
         environment
         `(lambda (&rest ,temp)
            (setq ,temp (car ,temp))
            (if (null ,temp)
                ,(cps client
                      else-ast
                      environment
                      continuation)
                ,(cps client
                      (ico:then-ast ast)
                      environment
                      continuation))))))
