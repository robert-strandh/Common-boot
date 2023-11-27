(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client environment (ast ico:if-ast) continuation)
  (let ((temp (gensym))
        (test-continuation (gensym))
        (then-continuation (gensym))
        (else-continuation (gensym))
        (temp-continuation (gensym))
        (test-ast (ico:test-ast ast))
        (then-ast (ico:then-ast ast))
        (else-ast (if (null (ico:else-ast ast))
                      (make-instance 'ico:literal-ast :literal nil)
                      (ico:else-ast ast))))
    `(let* ((,then-continuation
              (make-continuation
               (lambda ()
                 ,(cps client environment then-ast continuation))
               :origin ',(ico:origin then-ast)
               :next ,continuation))
            (,else-continuation
              (make-continuation
               (lambda ()
                 ,(cps client environment else-ast continuation))
               :origin ',(ico:origin else-ast)
               :next ,continuation))
            (,temp-continuation
              (make-continuation
               (lambda (&rest ,temp)
                 (setq ,temp (car ,temp))
                 (if (null ,temp)
                     (step '() ,else-continuation)
                     (step '() ,then-continuation)))))
            (,test-continuation
              (make-continuation
               (lambda ()
                 ,(cps client environment test-ast temp-continuation))
               :origin ',(ico:origin test-ast)
               :next ,temp-continuation)))
       (step '() ,test-continuation))))
