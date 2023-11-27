(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client environment (ast ico:if-ast) continuation)
  (let ((temp (gensym))
        (test-before-continuation (gensym))
        (test-after-continuation (gensym))
        (then-continuation (gensym))
        (else-continuation (gensym))
        (test-ast (ico:test-ast ast))
        (then-ast (ico:then-ast ast))
        (else-ast (if (null (ico:else-ast ast))
                      (make-instance 'ico:literal-ast :literal nil)
                      (ico:else-ast ast))))
    `(let* ((,then-continuation
              (make-before-continuation
               (lambda ()
                 ,(cps client environment then-ast continuation))
               :origin ',(ico:origin then-ast)
               :next ,continuation))
            (,else-continuation
              (make-before-continuation
               (lambda ()
                 ,(cps client environment else-ast continuation))
               :origin ',(ico:origin else-ast)
               :next ,continuation))
            (,test-after-continuation
              (make-after-continuation
               (lambda (&rest ,temp)
                 (setq ,temp (car ,temp))
                 (if (null ,temp)
                     (step '() ,else-continuation)
                     (step '() ,then-continuation)))
               :origin ',(ico:origin test-ast)
               :next ,continuation))
            (,test-before-continuation
              (make-before-continuation
               (lambda ()
                 ,(cps client environment test-ast test-after-continuation))
               :origin ',(ico:origin test-ast)
               :next ,test-after-continuation)))
       (step '() ,test-before-continuation))))
