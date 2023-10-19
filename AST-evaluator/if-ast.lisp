(cl:in-package #:common-boot-ast-evaluator)

;;; FIXME: remove new-continuaton.
(defmethod cps (client (ast ico:if-ast) continuation)
  (let ((temp (gensym "TEST"))
        (new-continuation (gensym "C-"))
        (continuation-variable (gensym "C-"))
        (else-ast (if (null (ico:else-ast ast))
                      (make-instance 'ico:literal-ast :literal nil)
                      (ico:else-ast ast))))
    `(let ((,continuation-variable
             (let ((,new-continuation ,continuation))
               (lambda (&rest ,temp)
                 (setq ,temp (car ,temp))
                 (if (null ,temp)
                     ,(cps client
                           else-ast
                           new-continuation)
                     ,(cps client
                           (ico:then-ast ast)
                           new-continuation))))))
       ,(cps client (ico:test-ast ast) continuation-variable))))
