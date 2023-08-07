(cl:in-package #:common-boot-ast-evaluator)

(defun cps-implicit-progn (client form-asts environment continuation)
  (let ((asts (reverse form-asts)))
    (when (null asts)
      (setf asts
            (list (make-instance 'ico:literal-ast :literal nil))))
    (let (first-name)
      `(let* ,(loop for form-ast in asts
                    for previous-name = continuation then name
                    for name = (gensym "C-")
                    collect `(,name (lambda (&rest ignore)
                                      (declare (ignore ignore))
                                      ,(cps client
                                            form-ast
                                            environment
                                            previous-name)))
                    finally (setf first-name name))
         (setf *arguments* '())
         (setf *continuation* ,first-name)))))

(defmethod cps (client (ast ico:progn-ast) environment continuation)
  (cps-implicit-progn client (ico:form-asts ast) environment continuation))
