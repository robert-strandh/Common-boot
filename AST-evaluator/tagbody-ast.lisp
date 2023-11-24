(cl:in-package #:common-boot-ast-evaluator)

(defun add-tags-to-host-table (segment-asts segment-names)
  (loop for segment-ast in segment-asts
        for segment-name in segment-names
        for tag-ast = (ico:tag-ast segment-ast)
        unless (null tag-ast)
          sum 1
          and do (setf (lookup tag-ast) segment-name)))

(defun push-tagbody-entry-form (segment-asts segment-names)
  `(let ((entry (make-instance 'tagbody-entry
                  :tag-entries
                  (list 
                   ,@(loop for segment-ast in segment-asts
                           for segment-name in segment-names
                           unless (null (ico:tag-ast segment-ast))
                             collect `(make-instance 'tag-entry
                                        :name ',segment-name
                                        :continuation ,segment-name))))))
     (push entry dynamic-environment)))

(defmethod cps (client environment (ast ico:tagbody-ast) continuation)
  (when (null (ico:segment-asts ast))
    (return-from cps
      `(step '(nil) ,continuation)))
  (let* ((segment-asts (ico:segment-asts ast))
         (ignore (gensym))
         (last-continuation
           `(make-continuation
             (lambda (&rest ,ignore)
               (declare (ignore ,ignore))
               (step '(nil) ,continuation))
             :origin ',(ico:origin ast)
             :next ,continuation))
         (last-continuation-name (gensym))
         (segment-names
           (loop for segment-ast in segment-asts collect (gensym))))
    (add-tags-to-host-table segment-asts segment-names)
    (let ((segment-continuations
            (loop for segment-ast in segment-asts
                  for continuation-name
                    in (rest (append segment-names
                                     (list last-continuation-name)))
                  collect `(make-continuation
                            (lambda (&rest ,ignore)
                              (declare (ignore ,ignore))
                              ,(cps client environment
                                    segment-ast
                                    continuation-name))
                            :origin ',(ico:origin segment-ast)
                            :next ,continuation-name))))
      `(let ((,last-continuation-name ,last-continuation))
         (let* ((dynamic-environment dynamic-environment)
                ,@(reverse (mapcar #'list
                                  segment-names segment-continuations)))
           (declare (ignorable dynamic-environment))
           ,(push-tagbody-entry-form segment-asts segment-names)
           (step '() ,(first segment-names)))))))
