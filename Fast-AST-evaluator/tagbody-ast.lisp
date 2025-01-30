(cl:in-package #:common-boot-fast-ast-evaluator)

(defun add-tags-to-host-table (segment-asts host-segment-names)
  (loop for segment-ast in segment-asts
        for host-segment-name in host-segment-names
        for tag-ast = (ico:tag-ast segment-ast)
        unless (null tag-ast)
          do (setf (lookup tag-ast) host-segment-name)))

(defun make-tagbody-entry-form (segment-asts host-segment-names)
  `(push (make-instance 'tagbody-entry
           :tag-entries
           (list 
            ,@(loop for segment-ast in segment-asts
                    for host-segment-name in host-segment-names
                    unless (null (ico:tag-ast segment-ast))
                      collect `(make-instance 'tag-entry
                                 :name ',host-segment-name
                                 :unwinder (lambda ()
                                             (go ,host-segment-name))))))
         dynamic-environment))

(defmethod translate-ast (client (ast ico:tagbody-ast))
  (let* ((segment-asts (ico:segment-asts ast))
         (host-segment-names (loop for segment-ast in segment-asts
                                   collect (gensym))))
    (add-tags-to-host-table segment-asts host-segment-names)
    `(let ((dynamic-environment dynamic-environment))
       (tagbody ,(make-tagbody-entry-form segment-asts host-segment-names)
          ,@(loop for segment-ast in segment-asts
                  for host-segment-name in host-segment-names
                  collect host-segment-name
                  collect (translate-ast client segment-ast))))))
