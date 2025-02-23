(cl:in-package #:common-boot-hir-evaluator)

(defmethod instruction-thunk
    (client
     (instruction hir:assignment-instruction)
     lexical-environment)
  (let ((input-register (first (hir:inputs instruction)))
        (output-register (first (hir:outputs instruction))))
    (cond ((eq (class-of input-register) (class-of output-register))
           (make-thunk (client instruction lexical-environment
                        :inputs 1 :outputs 1)
             (setf (output 0) (input 0))
             (successor 0)))
          ((typep input-register 'hir:single-value-register)
           (make-thunk (client instruction lexical-environment
                        :inputs 1 :outputs 1)
             (setf (output 0) (list (input 0)))
             (successor 0)))
          (t
           (make-thunk (client instruction lexical-environment
                        :inputs 1 :outputs 1)
             ;; We rely on the fact that (CAR NIL) => NIL.
             (setf (output 0) (car (input 0)))
             (successor 0))))))
