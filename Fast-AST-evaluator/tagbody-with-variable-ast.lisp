(cl:in-package #:common-boot-fast-ast-evaluator)

(defmethod translate-ast (client (ast ico:tagbody-with-variable-ast))
  (let* ((segment-asts (coerce (ico:segment-asts ast) 'vector))
         (segment-count (length segment-asts))
         (segment-thunk-forms (make-array (1+ segment-count)))
         (segments-variable (gensym))
         (index-variable (gensym))
         (host-variable (gensym)))
    (setf (svref segment-thunk-forms segment-count)
          `(lambda () (return nil)))
    (loop for i from (1- segment-count) downto 0
          for segment-ast = (svref segment-asts i)
          do (setf (svref segment-thunk-forms i)
                   `(lambda ()
                      ,(translate-ast client segment-ast )
                      (funcall (svref ,segments-variable ,(1+ i))))))
    (setf (lookup (ico:variable-definition-ast ast)) host-variable)
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
                       (catch ,host-variable
                         (funcall
                          (svref ,segments-variable ,index-variable))))))))))
