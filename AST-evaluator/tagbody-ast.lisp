(cl:in-package #:common-boot-ast-evaluator)

;;; Say the entire TAGBODY form is executed in a continuation C.
;;; Before the TAGBODY form is executed, the dynamic environment is D
;;; and the stack is S.  To establish a stack and a dynamic
;;; environment for the forms of the TAGBODY, we first push the stack.
;;; This operation Will create and stack S' so that the top frame F of
;;; S' contains C and D.  We then create another stack frame F' on top
;;; of the stack, creating the stack S''.  We then push TAG-ENTRYs
;;; E1-En (one for each tag in teh TAGBODY form) onto the dynamic
;;; environment, creating the dynamic environment D'.  Each Ei
;;; contains a continuation Ci corresponding to the associated tag,
;;; and each Ei contains S''.  S'' contains D'.
;;;
;;; So the normal control flow (i.e., no GO) means that the last form
;;; of the TAGBODY body is executed in a continuation that pops the
;;; stack twice.  This operation restores S, C and D,
;;;
;;; A non-local control transfer finds some Ei.  It then reinstates
;;; the stack from the stored information in Ei, i.e., S''.  And it
;;; reinstates the dynamic environment stored in F' on top of
;;; S''. This operation will restore S'', Ei, and D'.

(defmethod cps (client (ast ico:tagbody-ast) continuation)
  (let ((segment-asts (ico:segment-asts ast))
        (label-count 0))
    (loop for segment-ast in segment-asts
          for tag-ast = (ico:tag-ast segment-ast)
          do (unless (null tag-ast)
               (incf label-count)
               (setf (lookup tag-ast) (gensym))))
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
                                 new-continuation)
                           ,(unless (null tag-ast)
                              (let ((name (lookup tag-ast)))
                                `(push (make-instance 'tag-entry
                                         :name ',name
                                         :continuation new-continuation))))))
          finally (return action))))
