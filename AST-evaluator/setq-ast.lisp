(cl:in-package #:common-boot-ast-evaluator)

(defun setq-iterations
    (client environment tempc tempb tempa value-asts variable-reference-asts)
  (loop for value-ast in value-asts
        for variable-reference-ast in variable-reference-asts
        collect
        (if (typep variable-reference-ast 'ico:special-variable-reference-ast)
            `(,tempc (make-before-continuation
                      (lambda (&rest ,tempa)
                        (setq ,tempa (car ,tempa))
                        (setf (symbol-value
                               ',(ico:name variable-reference-ast)
                               ',(clostrum-sys:variable-cell
                                  client
                                  environment
                                  (ico:name variable-reference-ast))
                               dynamic-environment)
                              ,tempa)
                        (step (list ,tempa) ,tempc))
                      :origin ',(ico:origin variable-reference-ast)
                      :next ,tempc))
            (let* ((variable-definition-ast
                     (ico:definition-ast variable-reference-ast))
                   (host-variable (lookup variable-definition-ast)))
              `(,tempc (make-before-continuation
                        (lambda (&rest ,tempa)
                          (setq ,tempa (car ,tempa))
                          (setf (car ,host-variable) ,tempa)
                          (step (list ,tempa) ,tempc))
                        :origin ',(ico:origin value-ast)
                        :next ,tempc))))
        collect
        `(,tempc (make-before-continuation
                  (lambda (&rest ,tempb)
                    (declare (ignore ,tempb))
                    ,(cps client environment value-ast tempc))
                  :origin ',(ico:origin value-ast)
                  :next ,tempc))))

(defmethod cps (client environment (ast ico:setq-ast) continuation)
  (let ((value-asts (reverse (ico:value-asts ast)))
        (variable-reference-asts (reverse (ico:variable-name-asts ast)))
        (tempc (make-symbol "C"))
        (tempb (make-symbol "B"))
        (tempa (make-symbol "A")))
    `(let* ((,tempc ,continuation)
            ,@(setq-iterations
                client environment tempc tempb tempa value-asts variable-reference-asts))
       (step (list nil) ,tempc))))
