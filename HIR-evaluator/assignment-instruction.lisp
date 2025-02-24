(cl:in-package #:common-boot-hir-evaluator)

(defmethod ensure-thunk
    (client
     (instruction hir:assignment-instruction)
     lexical-environment)
  (let ((input-register (first (hir:inputs instruction)))
        (output-register (first (hir:outputs instruction))))
    (cond ((typep output-register 'hir:multiple-value-register)
           (if (typep input-register 'hir:multiple-value-register)
               (make-thunk (client instruction lexical-environment
                            :inputs 1 :outputs 1)
                 (setf (output 0) (input 0))
                 (successor 0))
               (make-thunk (client instruction lexical-environment
                            :inputs 1 :outputs 1)
                 (setf (output 0) (list (input 0)))
                 (successor 0))))
          (t
           (if (typep input-register 'hir:multiple-value-register)
               (make-thunk (client instruction lexical-environment
                            :inputs 1 :outputs 1)
                 ;; We rely on the fact that (CAR NIL) => NIL.
                 (setf (output 0) (car (input 0)))
                 (successor 0))
               (make-thunk (client instruction lexical-environment
                            :inputs 1 :outputs 1)
                 (setf (output 0) (input 0))
                 (successor 0)))))))
