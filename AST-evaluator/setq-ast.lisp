(cl:in-package #:common-boot-ast-evaluator)

(defun setq-iterations
    (client tempc tempb tempa value-asts variable-reference-asts)
  (loop for value-ast in value-asts
        for variable-reference-ast in variable-reference-asts
        for variable-definition-ast
          = (ico:variable-definition-ast variable-reference-ast)
        for host-variable = (lookup variable-definition-ast)
        collect
        `(,tempc (lambda (&rest ,tempa)
                   (setf (car ,host-variable) ,tempa)
                   (step ,tempa ,tempc)))
        collect
        `(,tempc (lambda (&rest ,tempb)
                   (declare (ignore ,tempb))
                   ,(cps client value-ast tempc)))))

(defmethod cps (client (ast ico:setq-ast) continuation)
  (let ((value-asts (reverse (ico:value-asts ast)))
        (variable-reference-asts (reverse (ico:variable-name-asts ast)))
        (tempc (make-symbol "C"))
        (tempb (make-symbol "B"))
        (tempa (make-symbol "A")))
    `(let* ((,tempc ,continuation)
            ,@(setq-iterations
                client tempc tempb tempa value-asts variable-reference-asts))
       (step (list nil) ,tempc))))

        
