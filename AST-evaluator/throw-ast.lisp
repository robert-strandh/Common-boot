(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:throw-ast) environment continuation)
  (declare (ignore continuation))
  (let ((tag (make-symbol "TAG"))
        (form (make-symbol "FORM")))
    (cps client
         (ico:tag-ast ast)
         environment
         `(lambda (&rest ,tag)
            (setq ,tag (car ,tag))
            ,(cps client
                  (ico:form-ast ast)
                  environment
                  `(lambda (&rest ,form)
                     (loop for entry in *dynamic-environment*
                           do (when (and (typep entry 'catch-entry)
                                         (eq (tag entry) ,tag))
                                (setq *arguments* (list ,form))
                                (setq *stack* (stack entry))
                                (setq *continuation* (continuation entry)))
                           finally (error "No active catch tag named ~s"
                                          ,tag))))))))
