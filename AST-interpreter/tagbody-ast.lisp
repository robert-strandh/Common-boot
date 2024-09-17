(cl:in-package #:common-boot-ast-interpreter)

(defmethod interpret-ast (client environment (ast ico:tagbody-ast))
  (let* ((*dynamic-environment* *dynamic-environment*)
         (catch-tag (gensym))
         (segment-asts (ico:segment-asts ast))
         (remaining-segment-asts segment-asts))
    (push (make-instance 'tagbody-entry
            :tag-entries
            (loop for rest-asts on remaining-segment-asts
                  for first-ast = (first rest-asts)
                  unless (null (ico:tag-ast first-ast))
                    collect (let ((rest-asts rest-asts)
                                  (tag-ast (ico:tag-ast first-ast)))
                              (make-instance 'tag-entry
                                :name tag-ast
                                :unwinder (lambda ()
                                            (setq remaining-segment-asts
                                                  rest-asts)
                                            (throw catch-tag nil))))))
          *dynamic-environment*)
    (loop until (null remaining-segment-asts)
          do (catch catch-tag
               (interpret-ast
                client environment (first remaining-segment-asts))
               (pop remaining-segment-asts)))))
