(cl:in-package #:common-boot-ast-evaluator)

(defun cps-implicit-progn (client form-asts environment continuation)
  (let ((asts (reverse form-asts)))
    (when (null asts)
      (setf asts
            (list (make-instance 'ico:literal-ast :literal nil))))
    (let ((name (gensym "C-")))
      `(let* ((,name ,continuation)
              ,@(loop for form-ast in asts
                      collect `(,name (lambda (&rest ignore)
                                        (declare (ignore ignore))
                                        ,(cps client
                                              form-ast
                                              environment
                                              name)))))
         (step '() ,name)))))

(defmethod cps (client (ast ico:progn-ast) environment continuation)
  (cps-implicit-progn client (ico:form-asts ast) environment continuation))
