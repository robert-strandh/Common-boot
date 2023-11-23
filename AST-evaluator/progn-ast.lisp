(cl:in-package #:common-boot-ast-evaluator)

(defun cps-implicit-progn (client environment form-asts continuation)
  (let ((asts (reverse form-asts)))
    (when (null asts)
      (setf asts
            (list (make-instance 'ico:literal-ast :literal nil))))
    (let ((name (gensym "C-")))
      `(let* ((,name ,continuation)
              ,@(loop for form-ast in asts
                      for ignore = (gensym "IGNORE")
                      collect `(,name (lambda (&rest ,ignore)
                                        (declare (ignore ,ignore))
                                        ,(cps client environment
                                              form-ast
                                              name)))))
         (step '() ,name)))))

(defmethod cps (client environment (ast ico:progn-ast) continuation)
  (cps-implicit-progn client environment (ico:form-asts ast) continuation))
