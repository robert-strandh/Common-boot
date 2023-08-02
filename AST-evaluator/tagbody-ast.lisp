(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:tagbody-ast) environment continuation)
  (let* ((temp (gensym))
         (segment-asts (ico:segment-asts ast))
         (label-count (- (length segment-asts)
                         (if (and (not (null segment-asts))
                                  (null (ico:tag-ast (first segment-asts))))
                             1 0)))
         (action `(progn
                    (loop repeat ,label-count do (pop *dynamic-environment*))
                    (step (list nil) ,continuation))))
    (loop for segment-ast in segment-asts
          for tag-ast = (ico:tag-ast segment-ast)
          for new-continuation = `(lambda (&rest ,temp)
                                    (declare (ignore ,temp))
                                    ,action)
          do (setf action
                   `(progn ,(cps client
                                 segment-ast
                                 environment
                                 new-continuation)
                           ,(unless (null tag-ast)
                              `(push (make-instance 'tag-entry
                                       :name ',(ico:name tag-ast)
                                       :continuation new-continuation))))))
    action))
