(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:tagbody-ast) environment continuation)
  (let ((temp (gensym))
        (action `(step (list nil) ,continuation)))
    (loop for segment-ast in (ico:segment-asts ast)
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
