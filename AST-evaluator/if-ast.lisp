(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:if-ast) continuation)
  (let ((temp (gensym "TEST"))
        (continuation-variable (gensym "C-"))
        (else-ast (if (null (ico:else-ast ast))
                      (make-instance 'ico:literal-ast :literal nil)
                      (ico:else-ast ast))))
    `(let ((,continuation-variable
             (lambda (&rest ,temp)
               (setq ,temp (car ,temp))
               (if (null ,temp)
                   ,(cps client
                         else-ast
                         continuation)
                   ,(cps client
                         (ico:then-ast ast)
                         continuation)))))
       ,(cps client (ico:test-ast ast) continuation-variable))))
