(cl:in-package #:common-boot-ast-evaluator)

(defun add-tags-to-host-table (segment-asts segment-names)
  (loop for segment-ast in segment-asts
        for segment-name in segment-names
        for tag-ast = (ico:tag-ast segment-ast)
        unless (null tag-ast)
          sum 1
          and do (setf (lookup tag-ast) segment-name)))

(defun make-tagbody-entry-form (segment-asts segment-names catch-tag)
  `(make-instance 'tagbody-entry
     :tag-entries
     (list 
      ,@(loop for segment-ast in segment-asts
              for segment-name in segment-names
              unless (null (ico:tag-ast segment-ast))
                collect `(make-instance 'tag-entry
                           :catch-tag ',catch-tag
                           :name ',segment-name
                           :continuation ,segment-name)))))

(defmethod cps (client environment (ast ico:tagbody-ast) continuation)
  (when (null (ico:segment-asts ast))
    (return-from cps
      `(step '(nil) ,continuation)))
  (let* ((segment-asts (ico:segment-asts ast))
         (ignore (gensym))
         (last-continuation-name (gensym))
         (segment-names
           (loop for segment-ast in segment-asts collect (gensym))))
    (add-tags-to-host-table segment-asts segment-names)
    (let ((catch-tag (gensym))
          (block (gensym))
          (segment-continuations
            (loop for segment-ast in segment-asts
                  for continuation-name
                    in (rest (append segment-names
                                     (list last-continuation-name)))
                  collect `(make-before-continuation
                            (lambda (&rest ,ignore)
                              (declare (ignore ,ignore))
                              (let ((dynamic-environment dynamic-environment))
                                (declare (ignorable dynamic-environment))
                                ,(cps client environment
                                      segment-ast
                                      continuation-name)))
                            :origin ',(ico:origin segment-ast)
                            :next ,continuation-name))))
      `(block ,block
         (let* ((;; We bind the target dynamic environment, and we add
                 ;; an entry to it that will be visible to the
                 ;; CPS-translated code of the segments.
                 dynamic-environment dynamic-environment)
                (;; The last continuation goes here, becuse we need to
                 ;; invalidate the block that we added to the top of
                 ;; the dynamic environment.
                 ,last-continuation-name
                  (make-before-continuation
                   (lambda (&rest ,ignore)
                     (declare (ignore ,ignore))
                     ;; Invalidate the top entry of the dynamic
                     ;; environment.  That entry was put there as a
                     ;; result of this BLOCK, and when the BLOCK
                     ;; terminates normally, it must be invalidated.
                     (invalidate-entry (first dynamic-environment))
                     (step '(nil) ,continuation)
                     (return-from ,block))
                   :origin ',(ico:origin ast)
                   :next ,continuation))
                ;; The segment continuations go here, so that the new
                ;; dynamic environment with the additional entry is
                ;; still on top when one of these continuations is
                ;; invoked.
                ,@(reverse (mapcar #'list
                                   segment-names segment-continuations))
                (ignore
                  (push ,(make-tagbody-entry-form
                          segment-asts segment-names catch-tag)
                        dynamic-environment)))
           (declare (ignore ignore))
           (declare (ignorable dynamic-environment))
           (step '() ,(first segment-names))
           (loop (catch ',catch-tag
                   (trampoline-iteration continuation dynamic-environment)
                   (apply continuation arguments))))))))
