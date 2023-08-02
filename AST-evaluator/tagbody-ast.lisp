(cl:in-package #:common-boot-ast-evaluator)

(defmethod cps (client (ast ico:tagbody-ast) environment continuation)
  (let ((segment-asts (ico:segment-asts ast))
        (label-count 0))
    (loop for segment-ast in segment-asts
          for tag-ast = (ico:tag-ast segment-ast)
          do (unless (null tag-ast)
               (incf label-count)
               (setf (lookup tag-ast environment) (gensym))))
    (loop with temp = (gensym)
          with action = `(progn
                           (loop repeat ,label-count
                                 do (pop *dynamic-environment*))
                           (step (list nil) ,continuation))
          for segment-ast in segment-asts
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
                              (let ((name (lookup tag-ast environment)))
                                `(push (make-instance 'tag-entry
                                         :name ',name
                                         :continuation new-continuation))))))
          finally (return action))))
