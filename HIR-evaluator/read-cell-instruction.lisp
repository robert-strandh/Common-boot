(cl:in-package #:common-boot-hir-evaluator)

(defmethod ensure-thunk
    (client
     (instruction hir:read-cell-instruction)
     lexical-environment)
  (make-thunk (client instruction lexical-environment
               :inputs 1 :outputs 1 :successors 1)
    (setf (output 0) (car (input 0)))
    (successor 0)))
