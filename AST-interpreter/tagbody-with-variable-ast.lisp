(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast
    (client environment (ast ico:tagbody-with-variable-ast))
  (let* ((*dynamic-environment* *dynamic-environment*)
         (variable-definition-ast (ico:variable-definition-ast ast))
         (catch-tag (gensym))
         (identity (list nil))
         (new-environment
           (acons variable-definition-ast identity environment))
         (segment-asts (ico:segment-asts ast))
         (remaining-segment-asts segment-asts))
    (push (make-instance 'tagbody-entry
            :identity identity
            :unwinders
            (coerce 
             (loop for rest-asts on remaining-segment-asts
                   for first-ast = (first rest-asts)
                   unless (null (ico:tag-ast first-ast))
                     collect (let ((rest-asts rest-asts))
                               (lambda ()
                                 (setq remaining-segment-asts
                                       rest-asts)
                                 (throw catch-tag nil))))
             'vector))
          *dynamic-environment*)
    (loop until (null remaining-segment-asts)
          do (catch catch-tag
               (interpret-ast
                client new-environment (first remaining-segment-asts))
               (pop remaining-segment-asts)))))
