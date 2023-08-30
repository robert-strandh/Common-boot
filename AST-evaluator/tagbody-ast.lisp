(cl:in-package #:common-boot-ast-evaluator)

(defun add-tags-to-host-table (segment-asts segment-names)
  (loop for segment-ast in segment-asts
        for segment-name in segment-names
        for tag-ast = (ico:tag-ast segment-ast)
        unless (null tag-ast)
          sum 1
          and do (setf (lookup tag-ast) segment-name)))

(defmethod cps (client (ast ico:tagbody-ast) continuation)
  (let* ((segment-asts (ico:segment-asts ast))
         (ignore (gensym))
         (last-continuation
           `(lambda (&rest ,ignore)
              (declare (ignore ,ignore))
              (step '(nil) ,continuation)))
         (last-continuation-name (gensym))
         (segment-names
           (loop for segment-ast in segment-asts collect (gensym))))
    (add-tags-to-host-table segment-asts segment-names)
    (let ((segment-continuations
            (loop for segment-ast in segment-asts
                  for continuation-name
                    in (rest (append segment-names
                                     (list last-continuation-name)))
                  collect `(lambda (&rest ,ignore)
                             (declare (ignore ,ignore))
                             ,(cps client
                                   segment-ast
                                   continuation-name)))))
      `(let* ((,last-continuation-name ,last-continuation)
              ,@(reverse (mapcar #'list segment-names segment-continuations)))
              
         ,@(loop for segment-ast in segment-asts
                 for segment-name in segment-names
                 unless (null (ico:tag-ast segment-ast))
                   collect `(push (make-instance 'tag-entry
                                    :stack *stack*
                                    :name ',segment-name
                                    :continuation ,segment-name)
                                  *dynamic-environment*))
         (step '()
               ,(if (null segment-names)
                    last-continuation-name
                    (first segment-names)))))))
