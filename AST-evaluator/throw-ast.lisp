(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:throw-ast) environment continuation)
  (declare (ignore continuation))
  (let ((temp (gensym)))
    (cps client
         (ico:tag-ast ast)
         environment
         `(lambda (&rest temp)
            (setq ,temp (car ,temp))
            ,(cps client
                  (ico:form-ast ast)
                  environment
                  `(lambda (&rest ,temp)
                     (loop for entry in *dynamic-environment*
                           do (when (and (typep entry 'catch-entry)
                                         (eq (tag entry) ,temp))
                                (setq *stack* (stack entry))
                                (setq *continuation (continuation entry)))
                           finally (error "No active catch tag named ~s"
                                          ,temp))))))))
