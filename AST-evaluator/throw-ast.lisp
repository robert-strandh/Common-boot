(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:throw-ast) continuation)
  (declare (ignore continuation))
  (let ((tag (make-symbol "TAG"))
        (form (make-symbol "FORM")))
    (cps client
         (ico:tag-ast ast)
         `(lambda (&rest ,tag)
            (setq ,tag (car ,tag))
            ,(cps client
                  (ico:form-ast ast)
                  `(lambda (&rest ,form)
                     (declare (ignore ,form))
                     (do-throw ,tag dynamic-environment)))))))
