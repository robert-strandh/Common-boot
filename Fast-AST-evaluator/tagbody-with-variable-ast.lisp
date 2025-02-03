(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:tagbody-with-variable-ast))
  (let* ((segment-asts (ico:segment-asts ast))
         (segment-asts-vector (coerce segment-asts 'vector))
         (offset (if (and (not (null segment-asts))
                          (null (ico:tag-ast (first segment-asts))))
                     1 0))
         (segment-count (length segment-asts))
         (segment-thunk-forms (make-array (1+ segment-count)))
         (segments-variable (gensym))
         (index-variable (gensym))
         (host-variable (gensym)))
    (setf (lookup (ico:variable-definition-ast ast)) host-variable)
    (setf (svref segment-thunk-forms segment-count)
          `(lambda () (return nil)))
    (loop for i from (1- segment-count) downto 0
          for segment-ast = (svref segment-asts-vector i)
          do (setf (svref segment-thunk-forms i)
                   `(lambda ()
                      ,(translate-ast client segment-ast )
                      (funcall (svref ,segments-variable ,(1+ i))))))
    `(let ((dynamic-environment dynamic-environment)
           (,host-variable (list nil)))
       (push (make-instance 'tagbody-entry
               :name ,host-variable)
             dynamic-environment)
       (block nil
         (let* (,segments-variable
                (,index-variable 0))
           (setf ,segments-variable
                 (vector ,@(coerce segment-thunk-forms 'list)))
           (loop (setf ,index-variable
                       (+ (catch ,host-variable
                            (funcall
                             (svref ,segments-variable ,index-variable)))
                          ,offset))))))))
