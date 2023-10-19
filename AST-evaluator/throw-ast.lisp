(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:throw-ast) continuation)
  (declare (ignore continuation))
  (let ((tag (make-symbol "TAG"))
        (form (make-symbol "FORM"))
        (continuation-variable (gensym "C-"))
        (tag-variable (gensym "T-")))
    `(let* ((,tag-variable nil)
            (,continuation-variable
              (lambda (&rest ,form)
                (declare (ignore ,form))
                (do-throw ,tag-variable dynamic-environment)))
            (,continuation-variable
              (lambda (&rest ,tag)
                (setq ,tag-variable (car ,tag))
                ,(cps client (ico:form-ast ast) continuation-variable))))
       ,(cps client (ico:tag-ast ast) continuation-variable))))
