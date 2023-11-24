(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client environment (ast ico:if-ast) continuation)
  (let ((temp (gensym "TEST"))
        (continuation-variable (gensym "C-"))
        (else-ast (if (null (ico:else-ast ast))
                      (make-instance 'ico:literal-ast :literal nil)
                      (ico:else-ast ast))))
    `(let ((,continuation-variable
             (make-continuation
              (lambda (&rest ,temp)
                (setq ,temp (car ,temp))
                (if (null ,temp)
                    ,(cps client environment
                          else-ast
                          continuation)
                    ,(cps client environment
                          (ico:then-ast ast)
                          continuation)))
              :origin ',(ico:origin ast)
              :next ,continuation)))
       ,(cps client environment (ico:test-ast ast) continuation-variable))))
