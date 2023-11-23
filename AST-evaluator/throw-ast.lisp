(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client environment (ast ico:throw-ast) continuation)
  (declare (ignore continuation))
  (let ((tag (make-symbol "TAG"))
        (form (make-symbol "FORM"))
        (continuation-variable (gensym "C-"))
        (tag-variable (gensym "T-")))
    `(let* ((,tag-variable nil)
            (,continuation-variable
              (lambda (&rest ,form)
                (declare (ignore ,form))
                (let ((entry (do-throw ,tag-variable dynamic-environment)))
                  (setf continuation (continuation entry)))))
            (,continuation-variable
              (lambda (&rest ,tag)
                (setq ,tag-variable (car ,tag))
                ,(cps client environment (ico:form-ast ast) continuation-variable))))
       ,(cps client environment (ico:tag-ast ast) continuation-variable))))
