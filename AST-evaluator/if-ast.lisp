(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:if-ast) environment continuation)
  (let ((temp (gensym)))
    (cps client
         (ico:test-ast ast)
         environment
         `(lambda (&rest ,temp)
            (setq ,temp (car ,temp))
            (if (null ,temp)
                ,(cps client
                      (ico:else-ast ast)
                      environment
                      continuation)
                ,(cps client
                      (ico:then-ast ast)
                      environment
                      continuation))))))
