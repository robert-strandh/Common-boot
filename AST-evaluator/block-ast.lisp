(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client environment (ast ico:block-ast) continuation)
  (let ((name (gensym))
        (block (gensym))
        (catch-tag (gensym))
        (temp (gensym))
        (end-condtinuation-variable (gensym "C-")))
    (setf (lookup (ico:name-ast ast)) name)
    `(block ,block
       (multiple-value-bind (c a)
           (catch ',catch-tag
             ;; This form never returns normally.  The only way the
             ;; CATCH returns is when there is a THROW to <tag>
             ;; which happens as a result of a RETURN-FROM in the
             ;; CPS-translated code.  When that happens, the dynamic
             ;; environment is automatically restored to its state
             ;; outside of the BLOCK.
             (let* ((;; We bind the target dynamic environment and
                     ;; we add an entry to it that will be visible
                     ;; to the CPS-translated code of FORM*.
                     dynamic-environment
                     (cons (make-instance 'block-entry
                             :continuation ,continuation
                             :catch-tag ',catch-tag
                             :name ',name)
                           dynamic-environment))
                    (;; The CPS translation of FORM* is done in this
                     ;; continuation.  So when the evaluation of
                     ;; FORM* finishes normally, the values produced
                     ;; are passed to this continuation.
                     ,end-condtinuation-variable
                     (make-before-continuation
                      (lambda (&rest ,temp)
                        ;; Invalidate the top entry of the dynamic
                        ;; environment.  That entry was put there as
                        ;; a result of this BLOCK, and when the
                        ;; BLOCK terminates normally, it must be
                        ;; invalidated.
                        (invalidate-entry (first dynamic-environment))
                        (step ,temp ,continuation)
                        ;; This RETURN-FROM removes CATCH-TAG from
                        ;; the host dynamic environment.  And we
                        ;; return to the infinite loop surrounding
                        ;; this one.
                        (return-from ,block))
                      :origin ',(ico:origin ast)
                      :next ,continuation))
                    (;; Finally, we bind DYNAMIC-ENVIRONMENT to
                     ;; itself, so that new entries added to it will
                     ;; not influence its previous value.
                     dynamic-environment dynamic-environment))
               (declare (ignorable dynamic-environment))
               (step '()
                     (make-before-continuation
                      (lambda ()
                        ,(cps-implicit-progn
                          client environment
                          (ico:form-asts ast)
                          end-condtinuation-variable))))
               (trampoline-loop)))
         (setf continuation c
               arguments a)))))

